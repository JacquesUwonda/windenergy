# Étape 0 : Introduction générale et présentation du projet

Bienvenue dans ce cours ! En tant qu'enseignant, mon objectif est de vous accompagner pour passer du statut de développeur débutant ayant quelques notions de Flutter à celui d'un développeur capable d'architecturer une application industrielle complète selon les règles de l'art.

---

## 1. Présentation de l'application : "WindEnergy"

### Le contexte métier : Monitoring d'une station d'énergie éolienne
**WindEnergy** est une application professionnelle destinée à la supervision et à la gestion d'un parc éolien. Dans une station d'énergie éolienne, chaque turbine génère de l'électricité à partir de la force cinétique du vent.

L'application répond à trois besoins fondamentaux :
1. **Authentification & Gestion des Techniciens** :
   Chaque technicien possède un compte sécurisé (`Profile`), lui donnant accès aux éoliennes qui lui sont attribuées sur le parc.
2. **Enregistrement et Appairage d'une Éolienne** :
   Lorsqu'un technicien prend en charge une nouvelle éolienne sur le site, il doit l'enregistrer (numéro de série, nom personnalisé, position GPS) et l'appairer via un code de sécurité temporaire (`PairingCode` à usage unique valable 15 minutes).
3. **Monitoring Énergétique en Temps Réel et Historique** :
   Une fois l'éolienne activée, l'application permet de surveiller :
   - La puissance électrique instantanée générée en Watts (`powerW`).
   - La vitesse de rotation du rotor en tours par minute (`rotationRpm`).
   - L'orientation de la nacelle par rapport au vent (`orientationDeg`).
   - Les statistiques horaires agrégées (`TelemetryHourly`) : puissance moyenne, pic maximal (`maxPowerW`), et énergie totale produite en Watt-heure (`energyWh`).
   - La puissance totale combinée de toutes les turbines actives du technicien via une vue SQL dédiée (`total_power_view`).

---

## 2. Les choix d'ingénierie logicielle

Ce projet applique les meilleures pratiques du développement logiciel professionnel :
- **Clean Architecture & MVVM** : Découpage strict et étanche en couches :
  - `domain` : Règles et entités métiers pures, indépendantes de tout framework et de toute base de données.
  - `data` : Services techniques (Supabase, GPS) et implémentation concrète des repositories.
  - `ui` : Présentation (Widgets Flutter et ViewModels réactifs).
  - `utils` : Gestion fonctionnelle des erreurs et exceptions.
- **Gestion Fonctionnelle des Erreurs (Pattern Result)** : Pas de crashs imprévus en production. Chaque opération retourne soit un `Success<T>`, soit un `Error<T>`.
- **Gestion de Session et Injection de Dépendances (`GetIt`)** : Découplage maximal des composants et conservation de l'état utilisateur connecté via un objet `Session`.
- **Base de Données Cloud PostgreSQL / Supabase** : Un schéma SQL robuste (`windenergy.sql`) avec sécurité au niveau des lignes (**Row Level Security - RLS**), triggers automatiques et fonctions stockées.
- **Tests Automatisés avec `mocktail`** : Une couverture de tests unitaires garantissant qu'aucune régression ne s'infiltre dans le code.

---

## 3. Feuille de route du parcours d'apprentissage

Le tutoriel est divisé en **4 grandes journées progressives** :
- **Jour 1 : Fondations, Architecture et Modélisation du Domaine (Partie 1)** (Création, dépendances, MVVM, Result, Profile, PairingCode).
- **Jour 2 : Modélisation Spatiale & Énergétique, et Contrats du Domaine** (Position, Turbine, Telemetry, Contrats de Repositories).
- **Jour 3 : Contrats de Services, Session et Implémentations Réelles** (Services abstraits, Gestion de session avec GetIt, Repositories réels et Tests avec Mocktail).
- **Jour 4 : Backend Supabase et Couche Présentation** (Setup Supabase, analyse du script SQL `windenergy.sql`, modèles Supabase, `SupabaseService` et démarrage de la couche UI).

---

## 4. Attendu final de cette étape

À la fin de cette lecture d'introduction, vous devez :
1. Avoir une vision claire du rôle de l'application **WindEnergy** et des défis d'ingénierie qu'elle résout.
2. Connaître la structure en 4 journées de notre progression pédagogique.
3. Être prêt à débuter par la pratique avec l'[Étape 1 : Création du projet et anatomie des fichiers](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/01_creation_projet_flutter.md).
