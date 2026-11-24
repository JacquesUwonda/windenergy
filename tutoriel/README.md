# Tutoriel Flutter : Construction pas à pas du projet WindEnergy

Bienvenue dans ce cours complet ! En tant qu'enseignant, je vous guide pas à pas dans la reproduction fidèle et la compréhension approfondie de l'application **WindEnergy**. 

**WindEnergy** est une application dédiée au **monitoring d'une station d'énergie éolienne**, permettant d'**enregistrer une éolienne** (via un code d'appairage sécurisé) et de **la monitorer** (puissance générée en Watts, rotation, direction, historique horaire).

Ce tutoriel est structuré par **Journées d'apprentissage** et reflète fidèlement la progression du code source du projet. Chaque fichier `.md` correspond à une notion/étape unique, explique en détail le **pourquoi** de chaque choix, détaille le code et se termine par un **attendu final**.

---

## 🧭 Sommaire complet des étapes

### 🌅 [Jour 1 : Fondations, Architecture et Premières Entités](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/)
- [Étape 0 : Introduction générale et présentation du projet](file:///d:/PROJECT2026/windenergy/tutoriel/00_introduction.md)  
  *Mission de l'application WindEnergy, concepts clés pour débutant et vision pédagogique.*

- [Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/01_creation_projet_flutter.md)  
  *Initialisation du projet avec `flutter create`, anatomie complète des dossiers générés (`android`, `ios`, `lib`, etc.) et nettoyage du code de départ.*

- [Étape 2 : Gestion des dépendances avec `pubspec.yaml`](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/02_gestion_des_dependances.md)  
  *Rôle de `pubspec.yaml`, ajout des dépendances du projet (`equatable`, `get_it`, `supabase_flutter`, `dotenv`, `http`, `google_fonts`, `mocktail`), pourquoi chacune est là.*

- [Étape 3 : Architecture logicielle MVVM et arborescence du projet](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/03_architecture_mvvm_et_arborescence.md)  
  *Pourquoi l'architecture est indispensable, principes du MVVM combiné à la Clean Architecture, et mise en place des dossiers dans `lib/`.*

- [Étape 4 : Gestion des erreurs avec le Pattern Result](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/04_pattern_result_gestion_erreurs.md)  
  *Pourquoi éviter les `try/catch` désordonnés ? Étude et reproduction du fichier `lib/utils/result.dart` (`Result<T>`, `Success<T>`, `Error`, `FutureResult<T>`).*

- [Étape 5 : Couche Domaine — L'Entité Profile](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/05_couche_domaine_entite_profile.md)  
  *Qu'est-ce qu'une entité métier ? Étude et reproduction du fichier `lib/features/domain/entities/profile.dart` (immutabilité, constructeur const, `Equatable`).*

- [Étape 6 : Couche Domaine — L'Entité PairingCode (Enregistrement)](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/06_couche_domaine_entite_pairing_code.md)  
  *Modélisation du mécanisme d'appairage sécurisé : étude et reproduction du fichier `lib/features/domain/entities/pairing_code.dart` (`enum PairingStatus`, hash de sécurité, gestion des dates).*

---

### ☀️ [Jour 2 : Domaine Complet, Contrats et Squelettes Data](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/)
- [Étape 7 : Couche Domaine — L'Entité Position (Géolocalisation)](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/07_couche_domaine_entite_position.md)  
  *Modélisation des coordonnées géodésiques de l'éolienne : étude de `lib/features/domain/entities/position.dart` (Value Object, encapsulation, Equatable).*

- [Étape 8 : Couche Domaine — L'Entité Turbine](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/08_couche_domaine_entite_turbine.md)  
  *Modélisation de l'éolienne industrielle : étude de `lib/features/domain/entities/turbine.dart` (`serialNumber`, `customName`, composition avec `Position`, `TurbineStatus`).*

- [Étape 9 : Couche Domaine — Télémétrie et Monitoring](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/09_couche_domaine_entites_telemetrie_et_monitoring.md)  
  *Modélisation de la télémétrie temps réel (`telemetry.dart`) et agrégée par heure (`telemetry_hourly.dart`) : puissance en Watts, rotation, giration et énergie en Watt-heure.*

- [Étape 10 : Couche Domaine — Contrats des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/10_couche_domaine_contrats_repositories.md)  
  *Principe d'Inversion des Dépendances (DIP) et Ségrégation des Interfaces (ISP) : contrats abstraits `authentification_repository.dart`, `profile_repository.dart` et `turbine_repository.dart`.*

- [Étape 11 : Couche Données — Services Abstraits](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/11_couche_donnees_services_abstraits.md)  
  *Séparation des responsabilités techniques : étude des interfaces de services `position_service.dart` (GPS) et `db_service.dart` (requêtes base de données).*

- [Étape 12 : Couche Données — Squelettes des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/12_couche_donnees_implementations_repositories.md)  
  *Démarche Contract-First : création des squelettes initiaux avec `throw UnimplementedError()`.*

---

### 🚀 [Jour 3 : Implémentations Réelles, Exceptions et Tests Unitaires](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/)
- [Étape 13 : Gestion des Exceptions et Typage Générique de `Error<T>`](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/13_gestion_des_exceptions_et_result_generique.md)  
  *Distinction entre exceptions techniques d'infrastructure et résultats métier : création de `lib/utils/exceptions.dart` (`ServerException`) et passage à `Error<T> extends Result<T>`.*

- [Étape 14 : Implémentation réelle des Repositories et Délégation à DbService](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/14_implementation_reelle_repositories_et_dbservice.md)  
  *Injection de `DbService` par constructeur, délégation des requêtes et interception des exceptions (`try / on ServerException catch (e) => return Error(reason: e.reason)`).*

- [Étape 15 : Tests Unitaires des Repositories avec Mocktail](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/15_tests_unitaires_repositories_avec_mocktail.md)  
  *Tests automatisés sans base de données réelle : utilisation de `mocktail` (`MockDbService`, `when`, `thenAnswer`, `thenThrow`), couverture complète et validation avec `flutter test`.*

---

## 📌 Méthode de travail recommandée

- **Suivez les étapes dans l'ordre chronologique (00 à 15)**.
- **Lisez attentivement les explications conceptuelles** pour comprendre le *pourquoi* avant le *comment*.
- **Vérifiez systématiquement l'attendu final** à la fin de chaque étape pour vous assurer que votre code est valide avant de passer à la suite.
