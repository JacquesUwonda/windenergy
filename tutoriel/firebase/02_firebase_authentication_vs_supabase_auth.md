# Firebase Étape 2 : Firebase Authentication vs Supabase Auth

L'authentification est la porte d'entrée de notre application de supervision éolienne. Dans ce chapitre, nous allons comparer en profondeur le fonctionnement de **Firebase Authentication** avec celui de **Supabase Auth**, et voir comment implémenter les méthodes de `DbService` avec Firebase.

---

## 1. Activation de l'authentification dans la Console Firebase

Avant d'écrire la moindre ligne de code :
1. Ouvrez votre projet sur la [Console Firebase](https://console.firebase.google.com/).
2. Dans le menu de gauche, cliquez sur **Build -> Authentication**.
3. Cliquez sur **Get started** (Commencer).
4. Dans l'onglet **Sign-in method**, activez le fournisseur **Email/Password** (Email et mot de passe).
5. Sauvegardez. Votre serveur Firebase Auth est immédiatement prêt à inscrire et connecter des techniciens !

---

## 2. Tableau comparatif : Firebase Auth vs Supabase Auth

| Fonctionnalité | Firebase Auth (`firebase_auth`) | Supabase Auth (`supabase_flutter`) |
| :--- | :--- | :--- |
| **Instance principale** | `FirebaseAuth.instance` | `supabaseClient.auth` |
| **Identifiant utilisateur** | `user.uid` (String) | `user.id` (UUID String) |
| **Méthode de connexion** | `signInWithEmailAndPassword(email, password)` | `signInWithPassword(email, password)` |
| **Méthode d'inscription** | `createUserWithEmailAndPassword(email, password)` | `signUp(email, password, data: {...})` |
| **Déconnexion** | `signOut()` | `signOut()` |
| **Utilisateur courant** | `FirebaseAuth.instance.currentUser` | `supabaseClient.auth.currentUser` |
| **Écoute de session** | `FirebaseAuth.instance.authStateChanges()` (Stream) | `supabaseClient.auth.onAuthStateChange` (Stream) |
| **Gestion des erreurs** | Lève une `FirebaseAuthException` avec un `.code` sous forme de kebab-case (ex: `'user-not-found'`) | Lève une `AuthException` avec un `.code` sous forme de snake_case (ex: `'invalid_credentials'`) |

---

## 3. Implémentation concrète : Comparaison de code ligne par ligne

Voyons comment s'écrivent les méthodes `signIn`, `signUp` et `signOut` dans notre service de base de données.

### A. Connexion (`signIn`)

#### En Firebase (`FirebaseService`) :
```dart
@override
FutureResult<String> signIn({String email = "", String password = ""}) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // userCredential.user!.uid est l'identifiant unique équivalent à user.id de Supabase
    return Success<String>(value: userCredential.user!.uid);
  } on FirebaseAuthException catch (e) {
    String reason = "Échec de connexion";
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        reason = "invalid credentials";
        break;
      case 'user-disabled':
        reason = "Compte technicien désactivé";
        break;
    }
    throw ServerException(reason: reason);
  } catch (e) {
    throw ServerException(reason: "an error occurred on the server");
  }
}
```

#### En Supabase (`SupabaseService`) :
```dart
// En Supabase, on utilisait :
final response = await supabaseClient.auth.signInWithPassword(
  email: email,
  password: password,
);
return Success<String>(value: response.session!.user.id);
```

---

### B. Inscription (`signUp`)

#### En Firebase (`FirebaseService`) :
```dart
@override
FutureResult<String> signUp({
  String fullName = "",
  String email = "",
  String password = "",
}) async {
  try {
    // 1. Création du compte d'authentification
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userId = userCredential.user!.uid;

    // 2. Mise à jour du profil (displayName)
    await userCredential.user!.updateDisplayName(fullName);

    // 3. Création du document profil dans Firestore (analogue au trigger SQL de Supabase)
    await FirebaseFirestore.instance.collection("profiles").doc(userId).set({
      "id": userId,
      "email": email,
      "full_name": fullName,
      "created_at": FieldValue.serverTimestamp(),
    });

    return Success<String>(value: userId);
  } on FirebaseAuthException catch (e) {
    String reason = "";
    switch (e.code) {
      case 'email-already-in-use':
        reason = "email address already exists in the system";
        break;
      case 'weak-password':
        reason = "Le mot de passe est trop faible";
        break;
    }
    throw ServerException(reason: reason);
  } catch (e) {
    throw ServerException(reason: "an error occurred on the server");
  }
}
```

> [!IMPORTANT]
> **Différence majeure à retenir** : 
> Dans **Supabase**, nous avions un trigger SQL `handle_new_user()` dans `windenergy.sql` qui créait la ligne dans `public.profiles` automatiquement.
> Dans **Firebase**, à moins de déployer une Cloud Function Node.js `functions.auth.user().onCreate(...)`, c'est notre méthode `signUp` qui insère directement le document dans la collection Firestore `profiles` !

---

### C. Déconnexion (`signOut`)

```dart
@override
FutureResult<dynamic> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    return Success();
  } catch (e) {
    throw ServerException(reason: "");
  }
}
```

---

## 4. Attendu final

Pour valider cette étape :
1. Vous comprenez la correspondance directe entre `FirebaseAuth` et `supabaseClient.auth`.
2. Les codes d'erreur de `FirebaseAuthException` sont interceptés et traduits en `ServerException(reason: reason)` pour que le reste de l'application réagisse de manière identique quel que soit le backend utilisé.

Passons à la structure des données NoSQL dans l'[Étape 3 : Cloud Firestore — Les Fondations NoSQL vs PostgreSQL](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/03_cloud_firestore_fondations_nosql_vs_postgresql.md).
