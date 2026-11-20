# Tutoriel Flutter : Construction pas à pas du projet WindEnergy

Bienvenue dans ce cours complet ! En tant qu'enseignant, je vous guide pas à pas dans la reproduction fidèle et la compréhension approfondie de l'application **WindEnergy**. 

**WindEnergy** est une application dédiée au **monitoring d'une station d'énergie éolienne**, permettant d'**enregistrer une éolienne** (via un code d'appairage sécurisé) et de **la monitorer**.

Ce tutoriel s'arrête exactement à l'état actuel d'avancement des fichiers du projet. Chaque fichier `.md` correspond à une notion/étape unique, explique en détail le **pourquoi** de chaque choix, détaille le code et se termine par un **attendu final**.

---

## 🧭 Sommaire des étapes disponibles

1. [Étape 0 : Introduction générale et présentation du projet](file:///d:/PROJECT2026/windenergy/tutoriel/00_introduction.md)
   *Mission de l'application WindEnergy, concepts clés pour débutant et vision pédagogique.*

2. [Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/01_creation_projet_flutter.md)
   *Initialisation du projet avec `flutter create`, anatomie complète des dossiers générés (`android`, `ios`, `lib`, etc.) et nettoyage du code de départ.*

3. [Étape 2 : Gestion des dépendances avec `pubspec.yaml`](file:///d:/PROJECT2026/windenergy/tutoriel/02_gestion_des_dependances.md)
   *Rôle de `pubspec.yaml`, ajout des dépendances du projet (`equatable`, `get_it`, `supabase_flutter`, `dotenv`, `http`, `google_fonts`, `mocktail`), pourquoi chacune est là.*

4. [Étape 3 : Architecture logicielle MVVM et arborescence du projet](file:///d:/PROJECT2026/windenergy/tutoriel/03_architecture_mvvm_et_arborescence.md)
   *Pourquoi l'architecture est indispensable, principes du MVVM combiné à la Clean Architecture, et mise en place des dossiers dans `lib/`.*

5. [Étape 4 : Gestion des erreurs avec le Pattern Result](file:///d:/PROJECT2026/windenergy/tutoriel/04_pattern_result_gestion_erreurs.md)
   *Pourquoi éviter les `try/catch` désordonnés ? Étude et reproduction du fichier `lib/utils/result.dart` (`Result<T>`, `Success<T>`, `Error`, `FutureResult<T>`).*

6. [Étape 5 : Couche Domaine — L'Entité Profile](file:///d:/PROJECT2026/windenergy/tutoriel/05_couche_domaine_entite_profile.md)
   *Qu'est-ce qu'une entité métier ? Étude et reproduction du fichier `lib/features/domain/entities/profile.dart` (immutabilité, constructeur const, `Equatable`).*

7. [Étape 6 : Couche Domaine — L'Entité PairingCode (Enregistrement d'éolienne)](file:///d:/PROJECT2026/windenergy/tutoriel/06_couche_domaine_entite_pairing_code.md)
   *Modélisation du mécanisme d'appairage sécurisé : étude et reproduction du fichier `lib/features/domain/entities/pairing_code.dart` (`enum PairingStatus`, hash de sécurité, gestion des dates).*

---

## 📌 Méthode de travail recommandée

- **Suivez les étapes dans l'ordre chronologique (00 à 06)**.
- **Lisez attentivement les explications conceptuelles** pour comprendre le *pourquoi* avant le *comment*.
- **Vérifiez systématiquement l'attendu final** à la fin de chaque étape pour vous assurer que votre code est valide avant de passer à la suite.
