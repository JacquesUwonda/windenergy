# Firebase Étape 1 : Installation de Node.js, Console Firebase et FlutterFire CLI

Pour connecter votre application Flutter à Firebase de façon moderne et sans risque d'erreur, Google a conçu un outil officiel : **FlutterFire CLI**. 
Cet outil s'occupe de configurer automatiquement vos projets Android, iOS, Web et génère le fichier de configuration Dart en une seule commande.

Pour que cet outil fonctionne, votre ordinateur a besoin d'un prérequis universel : **Node.js**. Ne vous inquiétez pas : vous n'aurez pas à apprendre le JavaScript ! Node.js sert uniquement de moteur d'exécution pour faire tourner l'outil d'installation de Google.

Dans cette étape, nous allons suivre un guide pas à pas complet :
1. Installation de Node.js.
2. Création du projet sur la Console Firebase.
3. Installation des outils CLI (`firebase-tools` et `flutterfire_cli`).
4. Configuration automatique du projet Flutter.

---

## 1. Installation pas à pas de Node.js

### Qu'est-ce que Node.js et NPM ?
- **[Node.js](https://nodejs.org/)** est un moteur qui permet d'exécuter des outils en ligne de commande.
- **NPM (Node Package Manager)** est le gestionnaire de paquets officiel de Node.js (l'équivalent de `pub` pour Dart). Il est automatiquement installé avec Node.js.

### Guide d'installation selon votre système d'exploitation :

#### 🪟 Sur Windows (Deux méthodes au choix) :
- **Méthode 1 (Recommandée - En une seule commande)** :
  Ouvrez votre terminal (PowerShell) et tapez :
  ```bash
  winget install OpenJS.NodeJS.LTS
  ```
- **Méthode 2 (Via l'installateur graphique)** :
  1. Rendez-vous sur le site officiel : [https://nodejs.org/](https://nodejs.org/).
  2. Cliquez sur le bouton vert **LTS (Long Term Support)** (la version la plus stable et recommandée).
  3. Téléchargez et exécutez le fichier `.msi`.
  4. Cliquez sur **Next** à chaque étape (laissez les options par défaut), cochez la case d'acceptation de licence, puis cliquez sur **Install**.

#### 🍏 Sur macOS :
- Si vous utilisez Homebrew :
  ```bash
  brew install node
  ```
- Ou téléchargez le fichier d'installation `.pkg` sur [nodejs.org](https://nodejs.org/).

#### 🐧 Sur Linux (Ubuntu/Debian) :
```bash
sudo apt update
sudo apt install nodejs npm
```

---

## 2. Vérification de l'installation de Node.js

Une fois l'installation terminée, **fermez et rouvrez votre terminal** pour recharger les variables d'environnement, puis vérifiez que tout fonctionne :

```bash
node -v
npm -v
```

### Ce que vous devez observer :
Le terminal affiche les versions installées (par exemple `v20.x.x` et `10.x.x`). Si ces numéros s'affichent, votre machine est 100% prête !

---

## 3. Création du Projet sur la Console Firebase

1. Rendez-vous sur la [Console Firebase](https://console.firebase.google.com/) et connectez-vous avec votre compte Google.
2. Cliquez sur **Ajouter un projet** (ou *Create a project*).
3. Donnez un nom à votre projet : `windenergy-station` (ou un nom unique de votre choix).
4. Google Analytics : vous pouvez le désactiver pour ce tutoriel (ou le laisser activé).
5. Cliquez sur **Créer le projet**. Patientez quelques secondes jusqu'au message *"Votre nouveau projet est prêt"*, puis cliquez sur **Continuer**.

---

## 4. Installation des outils officiels en ligne de commande

Maintenant que Node.js et NPM sont prêts, nous allons installer les deux utilitaires officiels de Google :

### A. Installer Firebase CLI (`firebase-tools`)
Dans votre terminal, exécutez :
```bash
npm install -g firebase-tools
```
*(Le flag `-g` signifie installation globale : l'outil sera accessible depuis n'importe quel dossier).*

Connectez-vous ensuite à votre compte Google Firebase :
```bash
firebase login
```
Une page de votre navigateur web va s'ouvrir pour vous demander d'autoriser l'accès. Acceptez. Votre terminal confirmera la connexion.

---

### B. Installer FlutterFire CLI
Installez l'outil d'intégration officiel pour Flutter :
```bash
dart pub global activate flutterfire_cli
```

> [!TIP]
> Si votre terminal affiche un avertissement indiquant que le chemin `flutterfire` n'est pas dans votre variable `PATH`, vous pouvez l'ajouter ou utiliser directement la commande `dart pub global run flutterfire_cli:flutterfire configure`.

---

## 5. Configuration automatique du projet avec `flutterfire configure`

Placez-vous dans le dossier racine de votre projet Flutter (`windenergy`) dans le terminal :

```bash
cd d:\PROJECT2026\windenergy
flutterfire configure
```

### Que fait cette commande magique ?
1. Elle interroge votre compte Firebase et liste vos projets : sélectionnez `windenergy-station` avec les flèches du clavier et appuyez sur Entrée.
2. Elle vous demande quelles plateformes configurer (Android, iOS, Web, Windows, etc.) : laissez toutes les plateformes cochées et appuyez sur Entrée.
3. **FlutterFire s'occupe de TOUT en coulisses :**
   - Il enregistre votre application Android avec son vrai package name.
   - Il configure les services Google.
   - Il génère automatiquement le fichier Dart officiel contenant toutes vos clés d'API : [lib/firebase_options.dart](file:///d:/PROJECT2026/windenergy/lib/firebase_options.dart).

---

## 6. Ajout des dépendances dans `pubspec.yaml`

Pour que notre code Flutter puisse interagir avec Firebase, nous ajoutons les trois paquets officiels de la suite [FlutterFire](https://firebase.flutter.dev/docs/overview) :

Exécutez dans votre terminal :
```bash
flutter pub add firebase_core firebase_auth cloud_firestore
```

### Rôle des paquets :
- **[`firebase_core`](https://pub.dev/packages/firebase_core)** : Initialise l'application et charge `firebase_options.dart`.
- **[`firebase_auth`](https://pub.dev/packages/firebase_auth)** : Gère l'authentification des techniciens.
- **[`cloud_firestore`](https://pub.dev/packages/cloud_firestore)** : Gère la base de données NoSQL dans le cloud.

---

## 7. Initialisation dans `lib/main.dart` : Comparatif avec Supabase

Regardons comment Firebase démarre proprement au lancement de l'application grâce au fichier généré `DefaultFirebaseOptions` :

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Fichier généré automatiquement par flutterfire configure

void main() async {
  // Obligatoire en Flutter avant d'exécuter du code asynchrone dans le main()
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================
  // INITIALISATION AVEC FIREBASE :
  // ==========================================
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ==========================================
  // ANALOGIE : COMMENT C'ÉTAIT AVEC SUPABASE :
  // ==========================================
  // await Supabase.initialize(
  //   url: 'https://votre-projet.supabase.co',
  //   anonKey: 'votre-cle-anon',
  // );

  runApp(const MaterialApp(
    title: "WindEnergy",
    home: Scaffold(
      body: Center(
        child: Text("WindEnergy connecté à Firebase avec succès !"),
      ),
    ),
  ));
}
```

---

## 8. Attendu final

Pour valider cette étape :
1. `node -v` et `npm -v` répondent correctement dans votre terminal.
2. La commande `flutterfire configure` a généré le fichier `lib/firebase_options.dart`.
3. Lancez votre application :
   ```bash
   flutter run
   ```
4. **Ce que vous devez observer :**
   - L'application compile sans aucune erreur de configuration native.
   - Le message *"WindEnergy connecté à Firebase avec succès !"* s'affiche sur votre écran ou émulateur.

Votre environnement Firebase est 100% opérationnel ! Passons à la gestion des comptes dans l'[Étape 2 : Firebase Authentication vs Supabase Auth](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/02_firebase_authentication_vs_supabase_auth.md).
