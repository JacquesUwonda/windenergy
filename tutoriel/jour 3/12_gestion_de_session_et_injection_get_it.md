# Étape 12 : Gestion de Session et Injection de Dépendances avec GetIt

Dans une application où un technicien s'authentifie, plusieurs couches ont besoin de savoir **qui** est connecté :
- Pour charger son profil (`readProfile(userId)`).
- Pour compter ses éoliennes (`readCount(userId)`).
- Pour créer une éolienne rattachée à son compte (`createTurbine(userId, ...)`).

Dans cette étape, nous allons étudier :
1. La classe `Session` dans `lib/features/data/repositories/session.dart`.
2. Le patron de conception **Service Locator** avec la bibliothèque `GetIt` pour propager la session sans encombrer les signatures de méthodes.

---

## 1. Pourquoi créer une classe `Session` ?

Passer le `userId` en paramètre de chaque appel d'écran en écran est fastidieux et source d'erreurs (phénomène de *Prop Drilling*).
Au lieu de cela, nous modélisons la session active sous la forme d'un objet immuable simple :

Créez le fichier [lib/features/data/repositories/session.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/session.dart) :

```dart
class Session {
  final String userId;
  const Session({this.userId = ""});
}
```

### Analyse :
- Une session contient l'identifiant unique de l'utilisateur (`userId`).
- Elle est immuable (`final`, constructeur `const`).
- Dès qu'un utilisateur se connecte, une `Session` est instanciée avec son `userId`.
- Dès qu'il se déconnecte, la session est détruite.

---

## 2. Le rôle du Service Locator `GetIt`

Comment partager cette `Session` avec `ProfileRepositoryImpl` et `TurbineRepositoryImpl` sans créer de couplage fort ?
Grâce au package **`get_it`** !

`GetIt` est un registre global en mémoire (Service Locator) ultra-rapide. Il permet d'enregistrer une instance (`registerSingleton`) et de la récupérer partout dans le code avec `GetIt.instance.get<T>()`.

### Le cycle de vie dynamique de la Session :
1. **À la connexion (`signIn` ou `signUp`)** :
   ```dart
   session = Session(userId: ret.value!);
   if (!getIt.isRegistered<Session>()) {
     getIt.registerSingleton<Session>(session!);
   }
   ```
2. **À la déconnexion (`signOut`)** :
   ```dart
   session = null;
   if (getIt.isRegistered<Session>()) {
     getIt.unregister<Session>();
   }
   ```
3. **Dans les autres repositories (`ProfileRepositoryImpl`, `TurbineRepositoryImpl`)** :
   ```dart
   final session = GetIt.instance.get<Session>();
   return await dbService.readProfile(userId: session.userId);
   ```

### Pourquoi cette approche est-elle élégante ?
- Les contrats du Domaine (`ProfileRepository.readProfile()`) restent épurés sans obliger l'appelant à fournir un `userId`.
- Si un appel est tenté alors qu'aucun utilisateur n'est connecté, `GetIt` lève immédiatement une alerte claire.
- Dans les tests unitaires, il suffit d'enregistrer une fausse session `GetIt.instance.registerSingleton<Session>(Session(userId: "0"))` dans le `setUp()`.

---

## 3. Attendu final

Pour valider cette étape :
1. Vérifiez que [lib/features/data/repositories/session.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/session.dart) existe.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur.
   - Le conteneur de session est prêt à être intégré dans nos implémentations de repositories.

Passons à l'[Étape 13 : Couche Données — Implémentations des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/13_couche_donnees_implementations_repositories.md).
