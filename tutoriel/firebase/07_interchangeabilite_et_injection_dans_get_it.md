# Firebase Étape 7 : Interchangeabilité Totale et Injection avec GetIt

Dans cette dernière étape du module Firebase, nous allons assister à la concrétisation ultime de tous les efforts architecturaux déployés depuis le Jour 1 : **la substitution transparente de backend**.

---

## 1. Le Principe de Substitution de Liskov (Le "L" de SOLID)

Rappelez-vous le principe de substitution de Liskov :
> *"Si une classe $S$ implémente une interface $T$, alors tout objet de type $T$ doit pouvoir être remplacé par un objet de type $S$ sans altérer le bon fonctionnement du programme."*

Dans **WindEnergy** :
- `DbService` est notre interface $T$.
- `SupabaseService` est une implémentation $S_1$.
- `FirebaseService` est une implémentation $S_2$.

Puisque nos Repositories (`AuthenticationRepositoryImpl`, `ProfileRepositoryImpl`, `TurbineRepositoryImpl`) dépendent uniquement de l'abstraction `DbService`, **ils ignorent totalement quel backend est branché** !

```text
                     ┌──────────────────┐
                     │    DbService     │ (Interface abstraite)
                     └────────▲─────────┘
                              │
               ┌──────────────┴──────────────┐
               │                             │
    ┌──────────────────┐          ┌──────────────────┐
    │ SupabaseService  │          │ FirebaseService  │
    └──────────────────┘          └──────────────────┘
```

---

## 2. Basculer de Supabase à Firebase dans `GetIt`

Où se fait le choix du backend dans notre code ? **En un seul et unique endroit : l'initialisation du Service Locator `GetIt` !**

Créons ou modifions un fichier d'injection de dépendances, par exemple `lib/injection_container.dart` :

```dart
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/services/db_service.dart';

// Import Supabase
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windenergy/features/data/services/supabase/supabase_service.dart';

// Import Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windenergy/features/data/services/firebase/firebase_service.dart';

// Repositories
import 'package:windenergy/features/domain/repositories/authentication_repository.dart';
import 'package:windenergy/features/data/repositories/authentication_repository_impl.dart';
import 'package:windenergy/features/domain/repositories/profile_repository.dart';
import 'package:windenergy/features/data/repositories/profile_repository_impl.dart';
import 'package:windenergy/features/domain/repositories/turbine_repository.dart';
import 'package:windenergy/features/data/repositories/turbine_repository_impl.dart';

final getIt = GetIt.instance;

enum BackendType { supabase, firebase }

void setupServiceLocator({BackendType backend = BackendType.supabase}) {
  // ========================================================
  // 1. CHOIX DU BACKEND EN UNE SEULE CONDITION :
  // ========================================================
  if (backend == BackendType.supabase) {
    getIt.registerLazySingleton<DbService>(
      () => SupabaseService(supabaseClient: Supabase.instance.client),
    );
  } else {
    getIt.registerLazySingleton<DbService>(
      () => FirebaseService(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );
  }

  // ========================================================
  // 2. LES REPOSITORIES NE CHANGENT STRICTEMENT JAMAIS :
  // ========================================================
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(dbService: getIt<DbService>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(dbService: getIt<DbService>()),
  );

  getIt.registerLazySingleton<TurbineRepository>(
    () => TurbineRepositoryImpl(dbService: getIt<DbService>()),
  );
}
```

---

## 3. Pourquoi les tests unitaires continuent-ils de passer ?

Rappelez-vous les tests unitaires écrits au [Jour 3 - Étape 14](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/14_tests_unitaires_des_repositories_avec_mocktail.md) :

```dart
class MockDbService extends Mock implements DbService {}
```

Dans nos tests, nous n'avions injecté ni `SupabaseService` ni `FirebaseService`, mais un `MockDbService`. 
Par conséquent :
- Le comportement de vos repositories a été validé de manière universelle.
- Que vous utilisiez Supabase en production ou Firebase sur un autre parc éolien, la logique métier reste garantie à 100%.

---

## 4. Synthèse comparative finale : Supabase vs Firebase

Pour conclure ce module, voici le mémo décisionnel que tout ingénieur Flutter doit avoir en tête :

| Situation | Privilégier Supabase | Privilégier Firebase |
| :--- | :--- | :--- |
| **Requêtes relationnelles complexes** (Jointures multiples, calculs SQL avancés, vues agrégées) | ✅ **Idéal** (PostgreSQL natif) | ❌ Complexe (nécessite de la dénormalisation manuelle) |
| **Mode hors-ligne natif** (Techniciens en sous-sol sans aucun réseau) | ⚠️ Nécessite du code custom ou du cache local | ✅ **Exceptionnel** (Cache Firestore automatique) |
| **Souveraineté des données & Auto-hébergement** | ✅ **Idéal** (100% open-source, Docker sur site) | ❌ Propriétaire (GCP uniquement) |
| **Intégration d'outils Google** (Google Analytics, Notifications Push FCM, Crashlytics) | ⚠️ Nécessite d'ajouter Firebase en parallèle | ✅ **Écosystème unifié en un clic** |

---

## 5. Attendu final

Pour valider l'ensemble du module Firebase :
1. Vous êtes capable d'expliquer comment basculer d'un backend à un autre sans toucher à l'interface graphique ni aux repositories.
2. Vous comprenez la complémentarité entre PostgreSQL (Supabase) et Firestore (Firebase).
3. Vous disposez de la boîte à outils complète pour bâtir des applications mobiles professionnelles parées pour n'importe quelle stack technologique !
