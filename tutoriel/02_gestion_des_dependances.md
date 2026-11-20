# Étape 2 : Gestion des dépendances avec pubspec.yaml

En Flutter et Dart, la gestion des bibliothèques externes se fait via un fichier central nommé `pubspec.yaml`. Dans ce chapitre, nous allons comprendre comment fonctionne l'écosystème de paquets [pub.dev](https://pub.dev), pourquoi nous choisissons chaque dépendance pour **WindEnergy**, et comment les installer proprement.

---

## 1. Qu'est-ce que `pubspec.yaml` ?

Le fichier `pubspec.yaml` est le fichier d'identité et de configuration de votre application. Il utilise le format YAML (indentation par espaces obligatoire, pas de tabulations).

Il contient trois grandes catégories d'informations :
1. **Les métadonnées** : Le nom (`name`), la description, la version (`version: 1.0.0+1`), et la version minimale du SDK Dart (`environment.sdk`).
2. **Les dépendances (`dependencies`)** : Les paquets nécessaires au fonctionnement de l'application en production.
3. **Les dépendances de développement (`dev_dependencies`)** : Les paquets utilisés uniquement pendant le développement et les tests (comme les outils de linting ou de mocking).

---

## 2. Analyse des dépendances du projet WindEnergy

Pourquoi ces dépendances précises ? Dans un projet professionnel, chaque paquet ajouté doit avoir une justification technique claire.

| Dépendance | Type | Pourquoi l'utiliser ? |
| :--- | :--- | :--- |
| **`cupertino_icons`** | UI | Fournit des icônes de style iOS complémentaires aux icônes Material standard. |
| **`equatable`** | Logique métier | En Dart, deux instances d'objets distincts avec les mêmes données ne sont pas égales par défaut (`o1 != o2`). `Equatable` permet la comparaison par valeur sans réécrire fastidieusement `==` et `hashCode`. |
| **`get_it`** | Architecture | Un conteneur d'inversion de contrôle (IoC / Service Locator). Il permet d'accéder à nos services et repositories partout dans l'app sans coupler nos classes. |
| **`supabase_flutter`** | Backend | SDK officiel pour interagir avec le cloud Supabase (authentification des techniciens, base PostgreSQL, tables de turbines et mesures). |
| **`dotenv`** | Sécurité | Permet de charger des variables d'environnement depuis un fichier `.env` pour éviter de coder en dur les URLs et clés d'API dans Git. |
| **`google_fonts`** | Design UI | Télécharge et met en cache automatiquement des polices Google élégantes pour une interface d'ingénierie moderne. |
| **`http`** | Réseau | Client HTTP standard pour effectuer des requêtes REST vers des API externes ou des passerelles IoT d'éoliennes. |
| **`mocktail`** | Dev/Test | Bibliothèque de mock moderne pour Dart (sans génération de code), indispensable pour tester notre logique sans serveur réel. |
| **`mock_supabase_http_client`**| Dev/Test | Permet de simuler les réponses Supabase lors des tests automatisés. |
| **`flutter_lints`** | Dev/Qualité | Ensemble officiel de règles d'analyse statique pour garantir un code propre et conforme aux standards de la communauté Flutter. |

---

## 3. Comment ajouter ces dépendances au projet ?

Vous avez deux manières de procéder. La méthode recommandée est d'utiliser la commande officielle `flutter pub add` dans votre terminal :

```bash
# 1. Dépendances de production
flutter pub add cupertino_icons equatable get_it google_fonts supabase_flutter dotenv http

# 2. Dépendances de développement et de tests
flutter pub add dev:flutter_lints dev:mocktail dev:mock_supabase_http_client
```

Cette commande modifie automatiquement votre `pubspec.yaml` et télécharge les paquets.

---

## 4. Le fichier `pubspec.yaml` complet de référence

Voici à quoi ressemble votre section `dependencies` dans `pubspec.yaml` :

```yaml
name: windenergy
description: "Application de monitoring et d'appairage d'une station d'énergie éolienne."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.13.1

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  equatable: ^3.0.0
  get_it: ^9.3.0
  google_fonts: ^9.0.0
  supabase_flutter: ^2.18.3
  dotenv: ^4.2.0
  http: ^1.6.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0
  mocktail: ^1.0.5
  mock_supabase_http_client: ^0.1.0

flutter:
  uses-material-design: true
```

Une fois le fichier enregistré, exécutez toujours dans votre terminal :
```bash
flutter pub get
```
Cette commande vérifie la compatibilité des versions, résout l'arbre de dépendances et génère le fichier `pubspec.lock`.

---

## 5. Attendu final

Pour valider cette étape :
1. Lancez dans le terminal :
   ```bash
   flutter pub get
   ```
2. **Ce que vous devez observer :**
   - Le terminal affiche : `Process finished with exit code 0` ou `Got dependencies!`.
   - Aucun message de conflit de dépendance rouge ne s'affiche.
   - Le fichier `pubspec.lock` est bien présent à la racine du projet.

Toutes nos briques techniques sont prêtes ! Passons à l'[Étape 3 : Architecture logicielle MVVM et création de l'arborescence](file:///d:/PROJECT2026/windenergy/tutoriel/03_architecture_mvvm_et_arborescence.md).
