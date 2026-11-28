# Tutoriel Flutter : Construction pas à pas du projet WindEnergy

Bienvenue dans ce cours complet d'ingénierie Flutter ! En tant qu'enseignant, je vous guide pas à pas dans la reproduction fidèle et la compréhension approfondie de l'application **WindEnergy**. 

**WindEnergy** est une application professionnelle dédiée à la **supervision et au monitoring d'une station d'énergie éolienne**, permettant d'**enregistrer et appairer une éolienne** (via un code d'appairage sécurisé temporaire) et de **la monitorer** (puissance électrique en Watts, vitesse de rotation du rotor en RPM, direction de la nacelle et historique horaire).

Le cours est conçu autour des principes de la **Clean Architecture** et du patron **MVVM**, avec une flexibilité totale de backend (**Supabase** et **Firebase**). Chaque fichier `.md` correspond à une notion/étape unique, explique en détail le **pourquoi** de chaque choix, décortique le code et se termine par un **attendu final**.

---

## 🧭 Sommaire complet du parcours

### 🌅 [Jour 1 : Fondations, Architecture et Modélisation du Domaine (Partie 1)](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/)
- [Étape 0 : Introduction générale et présentation du projet](file:///d:/PROJECT2026/windenergy/tutoriel/00_introduction.md)  
  *Mission de l'application WindEnergy, concepts clés pour débutant et vision pédagogique.*

- [Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/01_creation_projet_flutter.md)  
  *Initialisation du projet avec `flutter create`, anatomie complète des dossiers générés (`android`, `ios`, `lib`, etc.) et nettoyage du code de départ.*

- [Étape 2 : Gestion des dépendances avec `pubspec.yaml`](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/02_gestion_des_dependances.md)  
  *Rôle de `pubspec.yaml`, ajout des dépendances du projet (`equatable`, `get_it`, `supabase_flutter`, `dotenv`, `http`, `google_fonts`, `mocktail`), pourquoi chacune est là.*

- [Étape 3 : Architecture logicielle MVVM et arborescence du projet](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/03_architecture_mvvm_et_arborescence.md)  
  *Pourquoi l'architecture est indispensable, principes du MVVM combiné à la Clean Architecture, et mise en place des dossiers dans `lib/`.*

- [Étape 4 : Gestion des erreurs avec le Pattern Result et ServerException](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/04_pattern_result_gestion_erreurs.md)  
  *Pourquoi éviter les `try/catch` désordonnés ? Étude de `lib/utils/exceptions.dart` et `lib/utils/result.dart` (`Result<T>`, `Success<T>`, `Error<T>`, `FutureResult<T>`).*

- [Étape 5 : Couche Domaine — L'Entité Profile](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/05_couche_domaine_entite_profile.md)  
  *Qu'est-ce qu'une entité métier ? Étude du fichier `lib/features/domain/entities/profile.dart` (immutabilité, constructeur const, `Equatable`).*

- [Étape 6 : Couche Domaine — L'Entité PairingCode (Enregistrement)](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/06_couche_domaine_entite_pairing_code.md)  
  *Modélisation du mécanisme d'appairage sécurisé : étude de `lib/features/domain/entities/pairing_code.dart` (`enum PairingStatus`, hash de sécurité, gestion des dates).*

---

### ☀️ [Jour 2 : Modélisation Spatiale & Énergétique, et Contrats du Domaine](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/)
- [Étape 7 : Couche Domaine — L'Entité Position (Géolocalisation)](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/07_couche_domaine_entite_position.md)  
  *Modélisation des coordonnées géodésiques de l'éolienne : étude de `lib/features/domain/entities/position.dart` (Value Object, encapsulation, Equatable).*

- [Étape 8 : Couche Domaine — L'Entité Turbine](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/08_couche_domaine_entite_turbine.md)  
  *Modélisation de l'éolienne industrielle : étude de `lib/features/domain/entities/turbine.dart` (`serialNumber`, `customName`, composition avec `Position`, `TurbineStatus`).*

- [Étape 9 : Couche Domaine — Entités Télémétrie et Monitoring](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/09_couche_domaine_entites_telemetrie_et_monitoring.md)  
  *Modélisation de la télémétrie temps réel (`telemetry.dart` avec `rotationRpm`) et agrégée par heure (`telemetry_hourly.dart`) : puissance en Watts, rotation, giration et énergie en Watt-heure.*

- [Étape 10 : Couche Domaine — Contrats des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/10_couche_domaine_contrats_repositories.md)  
  *Principe d'Inversion des Dépendances (DIP) et Ségrégation des Interfaces (ISP) : contrats abstraits `authentication_repository.dart` (avec `isSignedIn()`), `profile_repository.dart` et `turbine_repository.dart`.*

- [Étape 11 : Couche Données — Services Abstraits](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/11_couche_donnees_services_abstraits.md)  
  *Séparation des responsabilités techniques : étude des interfaces de services `position_service.dart` (GPS) et `db_service.dart` (contrat technique unifié).*

---

### 🚀 [Jour 3 : Contrats de Services, Session et Implémentations Réelles](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/)
- [Étape 12 : Gestion de Session et Injection de Dépendances avec GetIt](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/12_gestion_de_session_et_injection_get_it.md)  
  *Modélisation de l'utilisateur connecté via `Session` (`lib/features/data/repositories/session.dart`), enregistrement dynamique et récupération avec le Service Locator `GetIt`.*

- [Étape 13 : Couche Données — Implémentations des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/13_couche_donnees_implementations_repositories.md)  
  *Implémentation concrète de `AuthenticationRepositoryImpl`, `ProfileRepositoryImpl` et `TurbineRepositoryImpl` : orchestration de la session, délégation à `DbService` et interception de `ServerException`.*

- [Étape 14 : Tests Unitaires des Repositories avec Mocktail](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/14_tests_unitaires_des_repositories_avec_mocktail.md)  
  *Tests automatisés sans base de données réelle : simulation de `DbService` avec `mocktail` (`when`, `thenAnswer`, `thenThrow`), vérification avec `expect` et couverture complète avec `flutter test`.*

---

### ⚡ [Jour 4 : Backend Supabase et Couche Présentation UI](file:///d:/PROJECT2026/windenergy/tutoriel/jour%204/)
- [Étape 15 : Setup Supabase et Décryptage du Script SQL `windenergy.sql`](file:///d:/PROJECT2026/windenergy/tutoriel/jour%204/15_setup_supabase_et_script_sql_windenergy.md)  
  *Setup cloud Supabase, décryptage complet du fichier `windenergy.sql` (extension `pgcrypto`, tables relationnelles, vues `turbines_with_status`, sécurité RLS, trigger `handle_new_user`, fonctions `turbine_insert_telemetry` et `turbine_activate`).*

- [Étape 16 : Couche Données — Modèles Supabase et SupabaseService](file:///d:/PROJECT2026/windenergy/tutoriel/jour%204/16_couche_donnees_supabase_modeles_et_service.md)  
  *Modèles DTO (`ProfileSupabaseModel`, `PositionSupabaseModel`, `TurbineSupabaseModel`, `PairingCodeSupabaseModel`) et implémentation concrète de `DbService` via `SupabaseService` (`SupabaseClient`, `AuthException`, requêtes SQL).*

- [Étape 17 : Introduction à la Couche UI et aux ViewModels (MVVM)](file:///d:/PROJECT2026/windenergy/tutoriel/jour%204/17_introduction_couche_ui_et_viewmodel.md)  
  *Structure de `lib/features/ui/`, composant réutilisable `CustomTextFormField`, conception de `LoginPage` et de son `LoginPageViewModel` réactif avec `ChangeNotifier`.*

---

### 🔥 [Module Spécialisé : Intégration Alternative avec Google Firebase](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/)
*Apprenez à maîtriser l'écosystème Google Cloud / Firebase et découvrez comment changer de backend sans réécrire l'application grâce à notre Clean Architecture.*

- [Étape 0 : Introduction à Firebase et Grand Comparatif Firebase vs Supabase](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/00_introduction_et_comparatif_firebase_vs_supabase.md)
- [Étape 1 : Setup de la Console Firebase et Configuration avec FlutterFire CLI](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/01_setup_firebase_console_et_flutterfire_cli.md)
- [Étape 2 : Firebase Authentication vs Supabase Auth](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/02_firebase_authentication_vs_supabase_auth.md)
- [Étape 3 : Cloud Firestore — Les Fondations NoSQL vs PostgreSQL](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/03_cloud_firestore_fondations_nosql_vs_postgresql.md)
- [Étape 4 : Sécurité des Données — Firestore Security Rules vs Supabase RLS](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/04_securite_firestore_rules_vs_supabase_rls.md)
- [Étape 5 : Modèles de Données DTO Firebase](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/05_modeles_donnees_firebase_dto.md)
- [Étape 6 : Implémentation Concrète de `FirebaseService`](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/06_implementation_concrete_firebase_service.md)
- [Étape 7 : Interchangeabilité Totale et Injection avec GetIt](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/07_interchangeabilite_et_injection_dans_get_it.md)

---

## 📌 Méthode de travail recommandée

- **Suivez les étapes dans l'ordre chronologique (00 à 17)**.
- **Lisez attentivement les explications conceptuelles** pour comprendre le *pourquoi* avant le *comment*.
- **Consultez le module Firebase** pour comparer chaque brique technique et développer des compétences polyvalentes SQL & NoSQL.
- **Vérifiez systématiquement l'attendu final** à la fin de chaque étape pour vous assurer que votre code est valide avant de passer à la suite.
