# Tutoriel Flutter : Construction pas à pas du projet WindEnergy

Bienvenue dans ce cours complet ! En tant qu'enseignant, je vous guide pas à pas dans la reproduction fidèle et la compréhension approfondie de l'application **WindEnergy**. 

**WindEnergy** est une application dédiée au **monitoring d'une station d'énergie éolienne**, permettant d'**enregistrer une éolienne** (via un code d'appairage sécurisé) et de **la monitorer** (puissance générée en Watts, rotation, direction, historique horaire).

Ce tutoriel s'arrête exactement à l'état actuel d'avancement des fichiers du projet. Chaque fichier `.md` correspond à une notion/étape unique, explique en détail le **pourquoi** de chaque choix, détaille le code et se termine par un **attendu final**.

---

## 🧭 Sommaire complet des étapes

### 📦 Phase 1 : Fondations et Architecture
- [Étape 0 : Introduction générale et présentation du projet](file:///d:/PROJECT2026/windenergy/tutoriel/00_introduction.md)  
  *Mission de l'application WindEnergy, concepts clés pour débutant et vision pédagogique.*

- [Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/01_creation_projet_flutter.md)  
  *Initialisation du projet avec `flutter create`, anatomie complète des dossiers générés (`android`, `ios`, `lib`, etc.) et nettoyage du code de départ.*

- [Étape 2 : Gestion des dépendances avec `pubspec.yaml`](file:///d:/PROJECT2026/windenergy/tutoriel/02_gestion_des_dependances.md)  
  *Rôle de `pubspec.yaml`, ajout des dépendances du projet (`equatable`, `get_it`, `supabase_flutter`, `dotenv`, `http`, `google_fonts`, `mocktail`), pourquoi chacune est là.*

- [Étape 3 : Architecture logicielle MVVM et arborescence du projet](file:///d:/PROJECT2026/windenergy/tutoriel/03_architecture_mvvm_et_arborescence.md)  
  *Pourquoi l'architecture est indispensable, principes du MVVM combiné à la Clean Architecture, et mise en place des dossiers dans `lib/`.*

- [Étape 4 : Gestion des erreurs avec le Pattern Result](file:///d:/PROJECT2026/windenergy/tutoriel/04_pattern_result_gestion_erreurs.md)  
  *Pourquoi éviter les `try/catch` désordonnés ? Étude et reproduction du fichier `lib/utils/result.dart` (`Result<T>`, `Success<T>`, `Error`, `FutureResult<T>`).*

---

### 🌐 Phase 2 : Couche Domaine (Entities)
- [Étape 5 : Couche Domaine — L'Entité Profile](file:///d:/PROJECT2026/windenergy/tutoriel/05_couche_domaine_entite_profile.md)  
  *Qu'est-ce qu'une entité métier ? Étude et reproduction du fichier `lib/features/domain/entities/profile.dart` (immutabilité, constructeur const, `Equatable`).*

- [Étape 6 : Couche Domaine — L'Entité PairingCode (Enregistrement d'éolienne)](file:///d:/PROJECT2026/windenergy/tutoriel/06_couche_domaine_entite_pairing_code.md)  
  *Modélisation du mécanisme d'appairage sécurisé : étude et reproduction du fichier `lib/features/domain/entities/pairing_code.dart` (`enum PairingStatus`, hash de sécurité, gestion des dates).*

- [Étape 7 : Couche Domaine — L'Entité Position (Géolocalisation)](file:///d:/PROJECT2026/windenergy/tutoriel/07_couche_domaine_entite_position.md)  
  *Modélisation des coordonnées géodésiques de l'éolienne : étude et reproduction du fichier `lib/features/domain/entities/position.dart` (Value Object, encapsulation, Equatable).*

- [Étape 8 : Couche Domaine — L'Entité Turbine](file:///d:/PROJECT2026/windenergy/tutoriel/08_couche_domaine_entite_turbine.md)  
  *Modélisation de l'éolienne industrielle : étude et reproduction du fichier `lib/features/domain/entities/turbine.dart` (`serialNumber`, `customName`, composition avec `Position`, `TurbineStatus`).*

- [Étape 9 : Couche Domaine — Télémétrie et Monitoring](file:///d:/PROJECT2026/windenergy/tutoriel/09_couche_domaine_entites_telemetrie_et_monitoring.md)  
  *Modélisation de la télémétrie temps réel (`telemetry.dart`) et agrégée par heure (`telemetry_hourly.dart`) : puissance en Watts, rotation, giration et énergie en Watt-heure.*

---

### 📑 Phase 3 : Couche Domaine (Contrats des Repositories)
- [Étape 10 : Couche Domaine — Contrats des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/10_couche_domaine_contrats_repositories.md)  
  *Principe d'Inversion des Dépendances (DIP) et Ségrégation des Interfaces (ISP) : étude de `authentification_repository.dart`, `profile_repository.dart` et `turbine_repository.dart`.*

---

### 💾 Phase 4 : Couche Données (Data Layer)
- [Étape 11 : Couche Données — Services Abstraits](file:///d:/PROJECT2026/windenergy/tutoriel/11_couche_donnees_services_abstraits.md)  
  *Séparation des responsabilités techniques : étude des contrats techniques de services `position_service.dart` (GPS) et `db_service.dart` (requêtes base de données).*

- [Étape 12 : Couche Données — Implémentations des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/12_couche_donnees_implementations_repositories.md)  
  *Démarche Contract-First : étude des classes squelettes concrètes `authentifiction_repository_impl.dart`, `profile_repository_impl.dart` et `turbine_repository_impl.dart`.*

---

## 📌 Méthode de travail recommandée

- **Suivez les étapes dans l'ordre chronologique (00 à 12)**.
- **Lisez attentivement les explications conceptuelles** pour comprendre le *pourquoi* avant le *comment*.
- **Vérifiez systématiquement l'attendu final** à la fin de chaque étape pour vous assurer que votre code est valide avant de passer à la suite.
