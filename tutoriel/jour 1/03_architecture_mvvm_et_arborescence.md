# Étape 3 : Architecture logicielle MVVM et création de l'arborescence

Dans cette étape cruciale, nous allons concevoir l'architecture de notre application **WindEnergy**. L'architecture logicielle n'est pas une contrainte superflue : c'est ce qui transforme un simple script en une application pérenne, testable et facile à faire évoluer à plusieurs développeurs.

---

## 1. Pourquoi une architecture ? Le problème du "Massive Widget"

Quand on débute avec Flutter, le premier réflexe est souvent d'écrire toute la logique dans le widget :
- On crée le formulaire de saisie dans le widget.
- Dans le `onPressed`, on appelle directement l'API Supabase via `http`.
- On manipule des chaînes de caractères brutes.
- Si la requête réussit, on appelle `setState(() { ... })`.

**Pourquoi est-ce une catastrophe à terme ?**
1. **Impossible à tester** : Pour tester la validation du code d'appairage, vous êtes obligé de lancer l'interface graphique et de cliquer sur des boutons.
2. **Dépendance toxique** : Si demain vous changez de backend (par exemple de Supabase vers une API REST interne), vous devez réécrire tous vos écrans !
3. **Violations des principes SOLID** : Notamment le principe de responsabilité unique (SRP - *Single Responsibility Principle*). Un écran doit afficher des données, pas gérer la cryptographie ou les requêtes SQL.

---

## 2. Le pattern MVVM (Model - View - ViewModel)

Pour structurer **WindEnergy**, nous adoptons le pattern **MVVM** articulé avec les principes de **Clean Architecture** :

```text
┌─────────────────┐        Observe / Écoute        ┌─────────────────┐
│                 │ ◄───────────────────────────── │                 │
│      VIEW       │                                │    VIEWMODEL    │
│  (Widgets UI)   │ ─────────────────────────────► │ (État & Logique)│
└─────────────────┘         Appelle actions        └─────────────────┘
                                                            │
                                                            │ Utilise
                                                            ▼
                                                   ┌─────────────────┐
                                                   │   REPOSITORY    │
                                                   │  (Abstraction)  │
                                                   └─────────────────┘
                                                            │
                                                            │ Implémente
                                                            ▼
                                                   ┌─────────────────┐
                                                   │   DATA SOURCE   │
                                                   │ (Supabase, API) │
                                                   └─────────────────┘
```

### Rôle de chaque couche :
1. **View (Vue)** :
   - Fichiers contenant vos widgets Flutter (`StatelessWidget`, `StatefulWidget`).
   - Son unique rôle : afficher les informations à l'écran et capter les actions de l'utilisateur (clics, saisies).
   - Elle ne contient **aucune logique métier** ni calcul complexe.
2. **ViewModel** :
   - C'est le chef d'orchestre de la vue.
   - Il expose l'état de l'écran (ex: "chargement en cours", "éolienne trouvée", "erreur de code").
   - Il reçoit les événements de la vue (ex: `onPairTurbineClicked(code)`), appelle le Repository, puis notifie la vue quand l'état change (via `notifyListeners()` de `ChangeNotifier`).
3. **Model & Domain (Modèle et Domaine)** :
   - Les entités pures de notre métier (`Profile`, `PairingCode`, `Turbine`).
   - Les contrats abstraits des opérations autorisées (`AuthRepository`, `TurbineRepository`).
4. **Data (Données)** :
   - Les implémentations techniques concrètes : tables Supabase, parsers JSON (`fromJson`), stockage local, requêtes HTTP.

---

## 3. Création de l'arborescence des dossiers

Nous organisons notre projet par **fonctionnalités (`features`)** et par **couches**. 

Ouvrez un terminal à la racine de votre projet et créez les répertoires suivants :

```bash
# Création des dossiers du projet
mkdir -p lib/core
mkdir -p lib/utils
mkdir -p lib/features/domain/entities
mkdir -p lib/features/domain/repositories
mkdir -p lib/features/data/models
mkdir -p lib/features/data/datasources
mkdir -p lib/features/data/repositories
mkdir -p lib/features/ui/viewmodels
mkdir -p lib/features/ui/views
mkdir -p lib/features/ui/widgets
```

*(Sur Windows PowerShell, vous pouvez lancer `New-Item -ItemType Directory -Force lib/core, lib/utils, lib/features/domain/entities, lib/features/domain/repositories, lib/features/data/models, lib/features/data/datasources, lib/features/data/repositories, lib/features/ui/viewmodels, lib/features/ui/views, lib/features/ui/widgets`)*

---

## 4. Carte de navigation de l'arborescence `lib/`

Voici la structure cible et le rôle précis de chaque sous-dossier :

```text
lib/
├── core/                           # Éléments partagés globaux (thème, constantes, injection)
│   ├── injection_container.dart    # Configuration de GetIt (Service Locator)
│   └── constants.dart              # Constantes (clés Supabase, routes)
│
├── utils/                          # Utilitaires génériques et transverses
│   └── result.dart                 # Classe de gestion des résultats (Success / Error)
│
├── features/                       # Fonctionnalités métier de WindEnergy
│   ├── domain/                     # 1. COUCHE DOMAINE (Indépendante de Flutter)
│   │   ├── entities/               # Objets métiers purs (Profile, PairingCode, Turbine)
│   │   └── repositories/           # Contrats d'accès aux données (interfaces abstraites)
│   │
│   ├── data/                       # 2. COUCHE DONNÉES (Implémentation concrète)
│   │   ├── models/                 # Modèles DTO sérialisables en JSON
│   │   ├── datasources/            # Appels directs à Supabase / API REST
│   │   └── repositories/           # Implémentation concrète des repositories du Domain
│   │
│   └── ui/               # 3. COUCHE PRÉSENTATION (Interface & MVVM)
│       ├── viewmodels/             # Logique d'écran (ChangeNotifier / ValueNotifier)
│       ├── views/                  # Pages / Écrans complets
│       └── widgets/                # Composants UI réutilisables (cartes, jauges, boutons)
│
└── main.dart                       # Initialisation et démarrage de l'application
```

### Pourquoi séparer `domain` et `data` ?
C'est la règle d'or de la Clean Architecture : **le Domaine ne dépend de rien, mais tout dépend du Domaine.**
- Si Supabase décide de renommer un champ dans sa base de données, seule la couche `data` est modifiée.
- Vos entités du `domain`, vos `viewmodels` et vos écrans restent intacts ! C'est ce qui offre une maintenabilité exceptionnelle.

---

## 5. Attendu final

Pour valider cette étape :
1. Dans votre explorateur de fichiers ou via le terminal, listez le dossier `lib/` :
   ```bash
   # Sur Windows PowerShell
   Get-ChildItem -Path lib -Recurse -Directory
   ```
2. **Ce que vous devez observer :**
   - Tous les dossiers ci-dessus (`features/domain`, `features/data`, `features/ui`, `utils`, `core`) sont créés.
   - Aucun fichier rouge d'erreur de compilation n'apparaît dans votre IDE.

La structure est en place ! Passons à l'[Étape 4 : Gestion fonctionnelle des erreurs (Pattern Result)](file:///d:/PROJECT2026/windenergy/tutoriel/04_pattern_result_gestion_erreurs.md).
