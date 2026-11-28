# Firebase Étape 4 : Sécurité des Données — Firestore Security Rules vs Supabase RLS

Dans le script [windenergy.sql](file:///d:/PROJECT2026/windenergy/windenergy.sql), nous avons activé le **Row Level Security (RLS)** de PostgreSQL avec des politiques comme :
`create policy "Users can select their own turbines" on public.turbines using ((select auth.uid()) = profile_id);`

Comment reproduire exactement ce niveau de sécurité industrielle avec Firebase ?
Grâce aux **Firestore Security Rules** !

---

## 1. Qu'est-ce que les Règles de Sécurité Firestore ?

Contrairement à un serveur backend traditionnel où vous écrivez du code Express/NestJS/Django pour vérifier les droits, dans Firebase, l'application mobile interagit **directement** avec la base Firestore.

Pour éviter qu'un utilisateur malveillant modifie les données d'un autre ou supprime une éolienne qui ne lui appartient pas, Google a créé un langage déclaratif puissant évalué directement sur les serveurs de Firestore : **`firestore.rules`**.

### Les variables clés disponibles dans chaque règle :
- **`request.auth`** : Contient les informations de l'utilisateur qui fait la requête. Si l'utilisateur n'est pas connecté, `request.auth` vaut `null`.
- **`request.auth.uid`** : L'identifiant unique de l'utilisateur connecté (analogue à `auth.uid()` de Supabase).
- **`resource.data`** : Les données déjà présentes dans le document ciblé avant modification.
- **`request.resource.data`** : Les nouvelles données que le client tente d'écrire.
- **`request.time`** : L'horodatage exact de la requête sur le serveur.

---

## 2. Le fichier de règles `firestore.rules` pour WindEnergy

Voici le fichier complet reproduisant la sécurité de `windenergy.sql` :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ==========================================
    // 1. RÈGLES DE LA COLLECTION PROFILES
    // ==========================================
    // Analogue à : using ((select auth.uid()) = id)
    match /profiles/{userId} {
      // Un utilisateur ne peut lire et modifier QUE son propre profil
      allow read, update: if request.auth != null && request.auth.uid == userId;
      // Création autorisée si l'ID correspond à l'utilisateur connecté
      allow create: if request.auth != null && request.auth.uid == userId;
      allow delete: if false; // Suppression interdite depuis l'app
    }

    // ==========================================
    // 2. RÈGLES DE LA COLLECTION TURBINES
    // ==========================================
    // Analogue à : using ((select auth.uid()) = profile_id and activated = true)
    match /turbines/{turbineId} {
      // Lecture : technicien connecté propriétaire de la turbine
      allow read: if request.auth != null && resource.data.profile_id == request.auth.uid;
      
      // Insertion : on force profile_id à être égal à l'utilisateur connecté
      allow create: if request.auth != null && request.resource.data.profile_id == request.auth.uid;
      
      // Mise à jour et suppression : réservées au technicien propriétaire
      allow update, delete: if request.auth != null && resource.data.profile_id == request.auth.uid;
    }

    // ==========================================
    // 3. RÈGLES DES CODES D'APPAIRAGE (PAIRING_CODES)
    // ==========================================
    match /pairing_codes/{codeId} {
      // Lecture autorisée pour les techniciens authentifiés
      allow read: if request.auth != null;
      
      // Validation : autorisée uniquement si le code n'est pas expiré
      // Analogue à : expires_at > now() and validated_at is null
      allow update: if request.auth != null 
                    && resource.data.expires_at > request.time 
                    && resource.data.validated_at == null;
    }

    // ==========================================
    // 4. RÈGLES DES TÉLÉMÉTRIES (TELEMETRIES & HOURLY)
    // ==========================================
    match /telemetries/{telemetryId} {
      // Lecture autorisée pour le technicien authentifié
      allow read: if request.auth != null;
      // Écriture : réservée aux éoliennes autorisées (ou backend)
      allow write: if request.auth != null;
    }

    match /telemetries_hourly/{hourlyId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 3. Tableau comparatif : Syntaxe RLS SQL vs Firestore Rules

| Concept de sécurité | Supabase (PostgreSQL RLS) | Firebase (Firestore Rules) |
| :--- | :--- | :--- |
| **Vérifier si connecté** | `TO authenticated` | `if request.auth != null` |
| **Identifiant utilisateur** | `(select auth.uid())` | `request.auth.uid` |
| **Propriétaire de la ligne** | `using (profile_id = (select auth.uid()))` | `if resource.data.profile_id == request.auth.uid` |
| **Contrôle à l'insertion** | `with check (profile_id = (select auth.uid()))` | `if request.resource.data.profile_id == request.auth.uid` |
| **Vérification temporelle** | `expires_at > now()` | `resource.data.expires_at > request.time` |

---

## 4. Déploiement des règles

Vous avez deux manières de publier ces règles :
1. **Via la Console Firebase** : Ouvrez **Firestore Database -> Règles (Rules)**, collez le contenu et cliquez sur **Publier**.
2. **Via le CLI Firebase** : Enregistrez le fichier à la racine de votre projet sous `firestore.rules` et lancez :
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## 5. Attendu final

Pour valider cette étape :
1. Vos règles de sécurité Firestore sont publiées.
2. Tout accès non authentifié est immédiatement bloqué par le serveur avec l'erreur `FirebaseException: [cloud_firestore/permission-denied]`.
3. Vos techniciens ne peuvent accéder qu'à leurs propres turbines.

Passons à la création des modèles Dart dans l'[Étape 5 : Modèles de Données DTO Firebase](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/05_modeles_donnees_firebase_dto.md).
