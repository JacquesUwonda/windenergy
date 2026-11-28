# Étape 15 : Setup Supabase et Décryptage du Script SQL `windenergy.sql`

Dans cette étape, nous plongeons dans l'infrastructure backend de notre application. Pour stocker nos données, gérer l'authentification et écouter la télémétrie en temps réel, nous utilisons **Supabase**, une plateforme Cloud open-source basée sur **PostgreSQL**.

À la racine de notre projet se trouve le fichier [windenergy.sql](file:///d:/PROJECT2026/windenergy/windenergy.sql). Dans ce chapitre, nous allons comprendre comment configurer Supabase et décortiquer chaque section de ce script SQL.

---

## 1. Setup initial de Supabase

Pour démarrer avec Supabase :
1. Créez un compte sur [supabase.com](https://supabase.com) et initialisez un nouveau projet nommé `windenergy`.
2. Définissez un mot de passe fort pour votre base de données PostgreSQL.
3. Une fois le projet provisionné, rendez-vous dans le menu **SQL Editor** du tableau de bord Supabase.
4. Copiez l'intégralité du contenu du fichier `windenergy.sql` et collez-le dans l'éditeur, puis cliquez sur **Run**.
5. Dans les paramètres de votre projet (**Project Settings -> API**), notez précieusement :
   - **Project URL** (ex: `https://xyzcompany.supabase.co`)
   - **Project API Anon Key** (la clé publique anonyme).

---

## 2. Décryptage approfondi du script `windenergy.sql`

Examinons les blocs architecturaux conçus dans `windenergy.sql` :

### A. Extension cryptographique et générateur de code d'appairage (Lignes 1-38)
```sql
create extension if not exists pgcrypto;

create or replace function public.random_alphanumeric_10()
returns text language plpgsql volatile as $$
...
$$;
```
- **`pgcrypto`** : Fournit des fonctions de cryptographie avancées (génération d'octets aléatoires `gen_random_bytes` et d'UUIDs `gen_random_uuid`).
- **`random_alphanumeric_10()`** : Génère une chaîne aléatoire de 10 caractères alphanumériques (majuscules, minuscules, chiffres). C'est cette fonction qui génère automatiquement nos codes d'appairage temporaires !

---

### B. Les Tables Relationnelles (Lignes 39-189)

1. **Table `profiles`** :
   ```sql
   create table if not exists public.profiles (
       id uuid primary key references auth.users(id) on delete cascade,
       full_name text,
       email text,
       created_at timestamptz default now()
   );
   ```
   - Chaque profil est lié à un compte d'authentification Supabase (`auth.users(id)`). Si l'utilisateur est supprimé d'auth, son profil est automatiquement supprimé en cascade (`on delete cascade`).

2. **Table `turbines`** :
   ```sql
   create table if not exists public.turbines (
       id serial primary key,
       profile_id uuid references public.profiles(id),
       serial_number text unique,
       custom_name text,
       sec_hash_code uuid,
       latitude double precision,
       longitude double precision,
       activated boolean default false,
       last_seen_at timestamptz default now(),
       created_at timestamptz default now()
   );
   ```
   - `profile_id` : Clé étrangère rattachant l'éolienne au technicien responsable.
   - `serial_number` : Identifiant physique constructeur unique.
   - `sec_hash_code` : Jeton secret (UUID) fourni à l'éolienne une fois activée pour authentifier ses envois de données.
   - `activated` : Vaut `false` à la création et devient `true` après l'appairage.
   - `last_seen_at` : Horodatage du dernier signal de vie émis par la turbine.

3. **Table `pairing_codes`** :
   - Stocke les codes d'appairage générés par `random_alphanumeric_10()`.
   - `expires_at` : Vaut par défaut `now() + interval '15 minutes'`. Passé ce délai, le code devient invalide.
   - `validated_at` : Horodatage de l'appairage réussi.

4. **Tables `telemetries` et `telemetries_hourly`** :
   - `telemetries` enregistre les mesures brutes : `power_w`, `rotation_rpm`, `orientation_deg`.
   - `telemetries_hourly` stocke les agrégats horaires : `avg_power_w`, `max_power_w`, `energy_wh`, `avg_rpm`.

---

### C. Les Vues SQL Intelligentes (Lignes 89-97, 130-137, 191-193)

Au lieu de faire des calculs fastidieux en Dart, la base de données calcule des vues optimisées :
1. **`turbines_with_status`** :
   Compare `last_seen_at` avec l'heure actuelle. Si la turbine n'a pas émis de signal depuis plus de 30 secondes, son statut passe automatiquement à `'INACTIVE'`, sinon elle est `'ACTIVE'` !
2. **`pairing_codes_with_status`** :
   Détermine si un code est `'VALID'` (s'il n'est pas encore validé et que la date d'expiration est dans le futur) ou `'INVALID'`.
3. **`total_power_view`** :
   Calcule instantanément la somme de la puissance électrique générée (`sum(power_w)`) pour chaque technicien (`profile_id`).

---

### D. La Sécurité au niveau des Lignes (RLS - Row Level Security) (Lignes 202-420)

Dans une application multi-utilisateurs, un technicien ne doit **jamais** voir les éoliennes ou les profils des autres techniciens.
Supabase utilise le **Row Level Security (RLS)** de PostgreSQL :

```sql
alter table public.turbines enable row level security;

create policy "Users can select their own turbines"
on public.turbines for select to authenticated
using ((select auth.uid()) = profile_id and activated = true);
```
- Même si un pirate intercepte l'API ou tente une requête générale `select * from turbines`, la base de données ne lui retournera **que** les lignes où `profile_id` est égal à son propre identifiant `auth.uid()`.

---

### E. Le Déclencheur Automatique (Trigger) de Profil (Lignes 209-228)

Lorsqu'un technicien s'inscrit via `signUp(email, password, fullName)` :
1. Supabase insère l'utilisateur dans `auth.users`.
2. Le trigger `on_auth_user_created` s'active immédiatement.
3. La fonction stockée `handle_new_user()` s'exécute et crée automatiquement la ligne correspondante dans `public.profiles` avec son `id`, son `email` et son `full_name`.

---

### F. Les Fonctions Stockées Sécurisées (Lignes 421-517)

1. **`turbine_insert_telemetry`** :
   Permet à l'éolienne de poster sa télémétrie en envoyant son `serial_number` et son jeton `sec_hash_code`. La fonction vérifie la validité du jeton, met à jour `last_seen_at` et insère la mesure dans `telemetries`.
2. **`turbine_activate`** :
   Prend un numéro de série et le code d'appairage. Si le code est valide, elle marque la turbine comme `activated = true`, invalide le code d'appairage et retourne un nouveau `sec_hash_code` sécurisé.

---

## 3. Attendu final

Pour valider cette étape :
1. Exécutez le script dans votre console SQL Supabase.
2. **Ce que vous devez observer :**
   - Toutes les tables (`profiles`, `turbines`, `pairing_codes`, `telemetries`, `telemetries_hourly`) sont créées.
   - Les vues (`turbines_with_status`, `pairing_codes_with_status`, `total_power_view`) sont opérationnelles.
   - Les politiques RLS sont actives pour protéger l'intégrité des données du parc.

Passons maintenant à la consommation de cette base en Dart dans l'[Étape 16 : Couche Données — Modèles Supabase et SupabaseService](file:///d:/PROJECT2026/windenergy/tutoriel/jour%204/16_couche_donnees_supabase_modeles_et_service.md).
