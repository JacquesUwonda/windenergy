# Étape 0 : Introduction générale et présentation du projet

Bienvenue dans ce cours ! L'objectif de ce tutoriel est de vous accompagner pour passer du statut de débutant ayant quelques notions de Flutter à celui d'un développeur capable de structurer et d'architecturer une application industrielle complète selon les règles de l'art.

---

## 1. Présentation de l'application : "WindEnergy"

### Le contexte métier : Monitoring d'une station d'énergie éolienne
**WindEnergy** est une application professionnelle destinée à la gestion d'un parc éolien. Dans une station d'énergie éolienne, chaque turbine génère de l'électricité à partir de la force cinétique du vent.

L'application répond à deux besoins fondamentaux :
1. **Enregistrer une éolienne** : Lorsqu'un technicien ou un opérateur prend en charge une nouvelle éolienne sur le site, il doit l'enregistrer (numéro de série, nom personnalisé, position GPS) et l'appairer de façon sécurisée à son compte technicien (`Profile`) à l'aide d'un code d'appairage (`PairingCode`).
2. **Monitorer l'éolienne en temps réel et en différé** : Une fois l'éolienne enregistrée, l'application permet de surveiller sa santé et ses performances opérationnelles :
   - Puissance instantanée produite en Watts (`powerW`).
   - Angle de rotation des pales (`rotationDeg`) et orientation face au vent (`orientationDeg`).
   - Statistiques horaires agrégées (`TelemetryHourly`) : puissance moyenne, puissance maximale, vitesse moyenne de rotation (RPM), et énergie totale injectée en Watt-heure (`energyWh`).
   - Vue globale du parc : nombre d'éoliennes actives (`readCount`) et puissance cumulée (`readTotalPowerW`).

---

## 2. Pourquoi ce projet est idéal pour apprendre Flutter ?

Ce projet couvre les grands défis de l'ingénierie mobile professionnelle :
- **Architecture rigoureuse (Clean Architecture & MVVM)** : Séparation stricte entre le Domaine (règles métier indépendantes), la Data (services, repositories, bases de données) et la Présentation (interface graphique).
- **Modélisation orientée objet poussée** : Immutabilité, Value Objects (`Position`), entités métier (`Turbine`, `Profile`, `PairingCode`) et données de séries temporelles (`Telemetry`, `TelemetryHourly`).
- **Gestion robuste des erreurs (Pattern Result)** : Remplacer les exceptions non gérées par des résultats typés (`Success<T>`, `Error`).
- **Conception guidée par les contrats (Contract-First)** : Définition des interfaces (`abstract class`) avant d'écrire l'implémentation technique.

---

## 3. Les prérequis pour ce cours

Pour tirer le meilleur parti de ce tutoriel, vous devez :
- Avoir installé le SDK Flutter et Dart sur votre machine.
- Connaître les concepts fondamentaux de la programmation orientée objet (classes, héritage, interfaces, constructeurs).
- Disposer d'un éditeur adapté (VS Code ou Android Studio avec les extensions Flutter et Dart).

---

## 4. Aperçu de la boîte à outils technique (Stack)

Au fil des étapes, nous manipulons les bibliothèques suivantes :
- **Flutter & Dart SDK** : Le framework UI multiplateforme.
- **`equatable`** : Pour comparer les objets par valeur sans surcharger manuellement `==` et `hashCode`.
- **`get_it`** : Pour l'injection de dépendances et le découplage via le pattern Service Locator.
- **`supabase_flutter`** : Pour la persistance en base de données PostgreSQL temps réel et l'authentification.
- **`dotenv`** : Pour la sécurité et la gestion des variables d'environnement.
- **`google_fonts`** : Pour une typographie soignée.
- **`mocktail`** & **`mock_supabase_http_client`** : Pour tester unitairement notre logique métier.

---

## 5. Attendu final de cette étape

À la fin de cette lecture d'introduction, vous devez :
1. Comprendre la mission de l'application **WindEnergy** : enregistrer une éolienne et surveiller ses indicateurs énergétiques.
2. Avoir en tête la structure générale de l'apprentissage que nous allons suivre étape par étape.
3. Être prêt à démarrer la pratique avec l'[Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/01_creation_projet_flutter.md).
