# Étape 1 : Création du projet et anatomie des fichiers

Dans cette première étape pratique, nous allons créer le projet Flutter à partir de zéro, examiner l'arborescence générée par l'outil en ligne de commande de Flutter et comprendre le rôle de chaque répertoire. Enfin, nous nettoierons le code par défaut afin de préparer une base saine.

---

## 1. Commande de création du projet

Ouvrez un terminal dans le répertoire où vous stockez vos projets (par exemple `D:\PROJECT2026\`) et exécutez la commande suivante :

```bash
flutter create --org com.windenergy windenergy
```

### Décryptage de la commande :
- `flutter create` : Indique au SDK Flutter d'initialiser une nouvelle application avec le squelette standard.
- `--org com.windenergy` : Définit le préfixe de package d'organisation (Reverse Domain Name). Sur Android, l'identifiant unique sera `com.windenergy.windenergy` et sur iOS le Bundle Identifier sera identique. C'est indispensable pour publier plus tard sur le Google Play Store ou l'Apple App Store.
- `windenergy` : Le nom du projet et du dossier créé. **Attention en Dart :** les noms de projets doivent impérativement être en minuscules avec des tirets bas (`snake_case`), sans espaces ni caractères accentués.

---

## 2. Anatomie de l'arborescence générée

Une fois la commande terminée, positionnez-vous dans le dossier :
```bash
cd windenergy
```

Voici ce que Flutter a créé pour vous :

```text
windenergy/
├── android/          # Projet natif Android (Gradle, Kotlin/Java, AndroidManifest.xml)
├── ios/              # Projet natif iOS (Xcode workspace, Swift/Obj-C, Info.plist)
├── linux/            # Code hôte pour bureau Linux
├── macos/            # Code hôte pour bureau macOS
├── windows/          # Code hôte pour bureau Windows
├── web/              # Fichiers d'hébergement web (index.html, manifest.json)
├── lib/              # LE CŒUR DE NOTRE TRAVAIL : Tout le code source Dart/Flutter
│   └── main.dart     # Point d'entrée de l'application
├── test/             # Tests unitaires et tests de widgets
├── pubspec.yaml      # Fichier manifeste : dépendances, polices, images, métadonnées
├── pubspec.lock      # Verrouille les versions exactes des dépendances installées
└── analysis_options.yaml # Configuration des règles d'analyse statique du code (linter)
```

### Pourquoi tous ces dossiers de plateformes (`android`, `ios`, etc.) ?
Flutter est un framework multiplateforme. Le code Dart que vous écrirez dans `lib/` sera exécuté à l'intérieur d'un "conteneur hôte" spécifique à chaque système d'exploitation. 
- Lorsque l'application compile pour Android, le code Flutter est intégré dans l'application Android native gérée par le dossier `android/`.
- De même pour iOS avec `ios/`.
Dans 95% des cas en tant que développeur Flutter, vous passerez votre temps dans le dossier `lib/`.

---

## 3. Le fichier `lib/main.dart` généré (Le compteur)

Par défaut, Flutter génère une application exemple : le fameux compteur (`Counter App`).
Ouvrez `lib/main.dart`. Vous y trouverez une classe `MyApp`, un `MyHomePage` et une fonction `_incrementCounter()`.

### Pourquoi ne devons-nous pas garder ce code tel quel ?
Cette application par défaut mélange dans un même fichier :
1. La configuration de l'application (`MaterialApp`).
2. L'interface graphique (`Scaffold`, `AppBar`, `Column`, `Text`).
3. La logique métier et la gestion d'état (`int _counter = 0; setState(...)`).

Dans une petite démonstration, cela fonctionne. Mais dans un projet réel comme **WindEnergy**, mélanger la logique et l'interface dans les mêmes fichiers conduit à ce qu'on appelle du **code spaghetti** : impossible à tester unitairement, impossible à maintenir et illisible dès que l'application grandit.

---

## 4. Nettoyage du fichier `lib/main.dart`

Pour débuter avec une base propre et minimaliste, remplacez le contenu de `lib/main.dart` par le code suivant :

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const WindEnergyApp());
}

/// [WindEnergyApp] est le widget racine de toute notre application.
/// Il est de type [StatelessWidget] car sa configuration globale
/// ne change pas au cours de l'exécution.
class WindEnergyApp extends StatelessWidget {
  const WindEnergyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WindEnergy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006699), // Couleur bleu éolien / industriel
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Bienvenue sur WindEnergy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
```

### Explications du code :
- `void main()` : Le point d'entrée universel de tout programme Dart.
- `runApp(...)` : Fonction fondamentale de Flutter qui attache le widget racine à l'écran du périphérique.
- `StatelessWidget` : Un widget immuable, qui ne possède pas d'état interne susceptible de changer avec le temps.
- `MaterialApp` : Le conteneur fourni par la bibliothèque Material Design qui configure la navigation, le thème visuel et la localisation.
- `Scaffold` : Le canevas de base d'une page (fournit la structure pour l'appBar, le body, les tiroirs de navigation, etc.).

---

## 5. Attendu final

Pour valider cette étape :
1. Exécutez l'application dans votre émulateur, simulateur ou navigateur web :
   ```bash
   flutter run
   ```
2. **Ce que vous devez observer :**
   - L'application démarre sans aucune erreur de compilation.
   - Un écran blanc s'affiche avec le texte centré : **"Bienvenue sur WindEnergy"**.
   - Le bandeau rouge de débogage ("DEBUG") a disparu dans le coin supérieur droit grâce à `debugShowCheckedModeBanner: false`.

Vous disposez maintenant d'un projet Flutter sain et prêt à accueillir une architecture professionnelle !
Passez à l'[Étape 2 : Gestion des dépendances avec pubspec.yaml](file:///d:/PROJECT2026/windenergy/tutoriel/02_gestion_des_dependances.md).
