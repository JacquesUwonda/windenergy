# Étape 3 : Architecture logicielle MVVM et arborescence du projet

Dans cette étape cruciale, nous allons comprendre et mettre en place l'architecture du projet **WindEnergy**. L'architecture logicielle est ce qui sépare un simple prototype d'une application professionnelle maintenable, testable et évolutive.

---

## 1. Pourquoi une architecture ?

Dans une application industrielle de supervision, mélanger l'interface graphique (les widgets), les appels réseau (Supabase) et la logique métier dans un même fichier conduit inévitablement au phénomène de **"code spaghetti"** :
- Impossible d'écrire des tests automatisés rapides.
- Dépendance totale envers la technologie de base de données : si vous changez d'outil, vous devez réécrire tous vos écrans.
- Risque élevé de régressions à chaque modification.

Pour éviter cela, nous combinons les principes de la **Clean Architecture** (proposée par Robert C. Martin "Uncle Bob") avec le patron de conception **MVVM** (Model-View-ViewModel).

---

## 2. Les 4 Couches du Projet WindEnergy

Notre code source dans `lib/` est rigoureusement compartimenté :

```text
┌────────────────────────────────────────────────────────┐
│                        UI                              │
│       Vues (Pages / Widgets) & ViewModels              │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                      DOMAIN                            │
│  Entités pures (Profile, Turbine...) & Contrats Repos  │
└───────────────────────────▲────────────────────────────┘
                            │ implémenté par
┌───────────────────────────┴────────────────────────────┘
│                       DATA                             │
│   Services (Supabase, GPS), Modèles DTO, Repositories  │
└────────────────────────────────────────────────────────┘
                            ▲
                            │ utilise
┌───────────────────────────┴────────────────────────────┘
│                      UTILS                             │
│       Result Pattern (Success/Error) & Exceptions      │
└────────────────────────────────────────────────────────┘
```

### Rôle de chaque couche :
1. **`lib/utils/` (Les outils transverses)** :
   Contient la gestion des résultats fonctionnels (`Result<T>`, `Success<T>`, `Error<T>`) et les exceptions techniques (`ServerException`).
2. **`lib/features/domain/` (Le Cœur Métier - Domaine)** :
   - `entities/` : Les objets métiers fondamentaux (`Profile`, `Turbine`, `PairingCode`, `Position`, `Telemetry`).
   - `repositories/` : Les **interfaces abstraites** (contrats) définissant ce que l'application sait faire, sans se soucier du *comment*.
   - **Règle absolue :** Le Domaine ne dépend d'aucune bibliothèque externe (ni Supabase, ni HTTP, ni widgets Flutter).
3. **`lib/features/data/` (La Couche Données)** :
   - `services/` : Les contrats et implémentations techniques pour interagir avec les API et le matériel (`DbService`, `SupabaseService`, `PositionService`).
   - `repositories/` : L'implémentation concrète des repositories du Domaine qui orchestrent les services et gèrent les sessions.
4. **`lib/features/ui/` (La Présentation MVVM)** :
   - `core/widgets/` : Composants graphiques réutilisables (`CustomTextFormField`, boutons, jauges).
   - `pages/` : Les écrans découpés par fonctionnalité, chacun accompagné de son **ViewModel** qui pilote son état logique.

---

## 3. Structure exacte des répertoires du projet

Voici l'arborescence complète à créer dans `lib/` :

```text
lib/
├── features/
│   ├── data/
│   │   ├── repositories/       # AuthenticationRepositoryImpl, TurbineRepositoryImpl...
│   │   │   └── session.dart    # Modélisation de la session active (userId)
│   │   └── services/           # DbService, PositionService
│   │       └── supabase/       # SupabaseService et ses modèles DTO (fromMap)
│   │           └── models/
│   ├── domain/
│   │   ├── entities/           # Profile, Turbine, PairingCode, Position, Telemetry...
│   │   └── repositories/       # AuthenticationRepository, TurbineRepository...
│   └── ui/
│       ├── core/
│       │   └── widgets/        # CustomTextFormField...
│       └── pages/
│           └── login/          # LoginPage et LoginPageViewModel
├── utils/
│   ├── exceptions.dart         # ServerException
│   └── result.dart             # Result<T>, Success<T>, Error<T>
└── main.dart                   # Point d'entrée de l'application
```

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que votre dossier `lib/` est structuré selon les 4 répertoires cardinaux : `features/data`, `features/domain`, `features/ui`, et `utils`.
2. Vous comprenez que le **Domain** est le cœur indépendant, que la **Data** fournit les données via des services et repositories, et que l'**UI** affiche les informations via des ViewModels.

Passons à la gestion fonctionnelle des erreurs dans l'[Étape 4 : Gestion des erreurs avec le Pattern Result](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/04_pattern_result_gestion_erreurs.md).
