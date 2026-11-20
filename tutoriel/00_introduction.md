# Étape 0 : Introduction générale et présentation du projet

Bienvenue dans ce cours ! En tant qu'enseignant, mon rôle est de vous guider pas à pas pour passer du statut de débutant qui "bidouille" du code Flutter à celui d'un développeur capable d'architecturer une application industrielle complète.

---

## 1. Présentation de l'application : "WindEnergy"

### Le contexte métier : Monitoring d'une station d'énergie éolienne
**WindEnergy** est une application professionnelle destinée à la gestion d'un parc éolien. Dans une station d'énergie éolienne, chaque turbine génère de l'électricité à partir de la force cinétique du vent.

L'application répond à deux besoins fondamentaux :
1. **Enregistrer une éolienne** : Lorsqu'un technicien ou opérateur prend en charge une nouvelle éolienne sur le site, il doit l'appairer de façon sécurisée à son compte technicien (`Profile`) à l'aide d'un code d'appairage (`PairingCode`). Cela garantit que seules les personnes autorisées peuvent agir sur l'équipement.
2. **Monitorer l'éolienne en temps réel** : Une fois l'éolienne enregistrée, l'application permet de surveiller sa santé et ses performances opérationnelles :
   - Vitesse et direction du vent (en m/s et degrés).
   - Puissance instantanée produite (en kW ou MW).
   - Vitesse de rotation du rotor (tours par minute - RPM).
   - Statut opérationnel (En production, En maintenance, Arrêt d'urgence) et alertes techniques.

---

## 2. Pourquoi ce projet est parfait pour apprendre Flutter ?

Ce projet couvre l'ensemble des défis qu'un développeur Flutter rencontre en entreprise :
- **Modélisation de données réelles** : Manipulation d'objets avec états, identifiants, dates d'expiration et contraintes physiques.
- **Séparation claire des responsabilités (MVVM + Clean Architecture)** : L'interface utilisateur ne doit jamais communiquer directement avec la base de données.
- **Robustesse et gestion d'erreurs (Pattern Result)** : Pas de crash inopiné sur le terrain en cas de perte de réseau.
- **Backend as a Service moderne (Supabase)** : Authentification sécurisée et base de données PostgreSQL temps réel.
- **Architecture testable et évolutive** : Utilisation de l'injection de dépendances (`GetIt`) et de mocks de test (`Mocktail`).

---

## 3. Les prérequis pour ce cours

Pour tirer le meilleur parti de ce tutoriel, vous devez :
- Avoir installé le SDK Flutter et Dart (la commande `flutter doctor` doit être fonctionnelle).
- Avoir quelques notions de base en programmation orientée objet (qu'est-ce qu'une classe, un objet, une variable, une méthode).
- Avoir un éditeur de texte configuré (VS Code ou Android Studio avec le plugin Flutter).

---

## 4. Aperçu de la boîte à outils technique (Stack)

Voici les outils et bibliothèques que nous allons intégrer au fur et à mesure :
- **Flutter & Dart SDK** : Le framework UI multiplateforme.
- **Equatable** : Pour comparer les objets par valeur (indispensable pour que Flutter sache quand reconstruire l'interface).
- **GetIt** : Le "Service Locator" qui gère l'injection de dépendances sans alourdir l'arborescence de widgets.
- **Supabase Flutter** : Pour gérer la base de données en ligne, l'authentification et les mises à jour temps réel.
- **Dotenv** : Pour stocker les clés d'API dans un fichier `.env` non versionné sur Git.
- **Google Fonts** : Pour appliquer une typographie industrielle soignée.
- **Mocktail** : Pour créer des tests unitaires rapides et isolés du réseau.

---

## 5. Attendu final de cette étape

À la fin de cette lecture, vous devez :
1. Comprendre la mission de l'application **WindEnergy** : enregistrer une éolienne via son code d'appairage et surveiller ses données de production éolienne.
2. Avoir en tête la structure générale de l'apprentissage que nous allons suivre étape par étape.
3. Être prêt à démarrer la pratique avec l'[Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/01_creation_projet_flutter.md).
