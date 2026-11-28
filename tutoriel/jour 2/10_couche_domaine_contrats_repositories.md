# Étape 10 : Couche Domaine — Contrats des Repositories

En Clean Architecture, la couche **Domaine** est le chef d'orchestre : elle ne dépend d'aucune base de données, ni d'aucun paquet tiers. Elle définit uniquement des **contrats abstraits** (`abstract class`) qui spécifient ce que l'application doit pouvoir réaliser.

Dans cette étape, nous allons étudier et reproduire les 3 contrats de Repositories :
1. `AuthenticationRepository` (Sécurité et sessions).
2. `ProfileRepository` (Profil technicien).
3. `TurbineRepository` (Gestion et monitoring des éoliennes).

---

## 1. Pourquoi des interfaces abstraites ? Le principe d'inversion des dépendances

Le principe **DIP** (*Dependency Inversion Principle*) de SOLID stipule que les modules de haut niveau (le domaine métier) ne doivent pas dépendre des modules de bas niveau (les détails techniques comme Supabase ou SQL). Les deux doivent dépendre d'abstractions.

En définissant des contrats abstraits :
- Les ViewModels et l'interface utilisateur s'appuient uniquement sur ces interfaces.
- Si demain nous changeons de système de base de données, pas une seule ligne du Domaine ni de l'UI n'aura besoin d'être modifiée !

---

## 2. Le contrat `AuthenticationRepository`

Ouvrez ou créez le fichier [lib/features/domain/repositories/authentication_repository.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/repositories/authentication_repository.dart) :

```dart
import 'package:windenergy/utils/result.dart';

abstract class AuthenticationRepository {
  FutureResult signIn({String email, String password});
  FutureResult signUp({String fullName, String email, String password});
  FutureResult signOut();
  FutureResult<bool> isSignedIn();
}
```

### Analyse pédagogique :
- `signIn({String email, String password})` : Authentification de l'opérateur avec ses identifiants.
- `signUp(...)` : Inscription d'un nouveau technicien sur la plateforme.
- `signOut()` : Déconnexion sécurisée et destruction de la session courante.
- `isSignedIn()` : Vérifie si un technicien est actuellement connecté (permet de décider s'il faut afficher l'écran de Login ou le Dashboard au démarrage de l'app).

---

## 3. Le contrat `ProfileRepository`

Ouvrez ou créez le fichier [lib/features/domain/repositories/profile_repository.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/repositories/profile_repository.dart) :

```dart
import "package:windenergy/features/domain/entities/profile.dart";
import "package:windenergy/utils/result.dart";

abstract class ProfileRepository {
  FutureResult<Profile> readProfile();
}
```

### Analyse pédagogique :
- `readProfile()` retourne un `FutureResult<Profile>`. Remarquez que la méthode ne demande aucun paramètre `userId` : c'est le rôle de l'implémentation de récupérer l'identifiant de la session courante !

---

## 4. Le contrat `TurbineRepository`

Ouvrez ou créez le fichier [lib/features/domain/repositories/turbine_repository.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/repositories/turbine_repository.dart) :

```dart
import "package:windenergy/features/domain/entities/pairing_code.dart";
import "package:windenergy/features/domain/entities/position.dart";
import "package:windenergy/features/domain/entities/turbine.dart";
import "package:windenergy/utils/result.dart";

abstract class TurbineRepository {
  FutureResult<int> readCount();
  FutureResult<double> readTotalPowerW();
  FutureResult<List<Turbine>> readTurbines();
  FutureResult<int> createTurbine({
    String serialNumber,
    String customName,
    Position position,
  });
  FutureResult<PairingCode> readPairingCode({int turbineId});
  FutureResult readTurbineActivation();
  FutureResult updateTurbine({
    int turbineId,
    String customName,
    Position position,
  });
  FutureResult deleteTurbine({int turbineId});
}
```

### Analyse des opérations métiers :
- **Supervision globale** :
  - `readCount()` : Nombre d'éoliennes actives associées au technicien.
  - `readTotalPowerW()` : Puissance totale combinée produite par l'ensemble du parc.
  - `readTurbines()` : Récupération de la liste des éoliennes avec leur statut.
- **Cycle de vie de la turbine** :
  - `createTurbine(...)` : Enregistrement d'une nouvelle éolienne sur le site (retourne le nouvel identifiant `int` généré).
  - `readPairingCode(...)` : Obtention du code d'appairage pour coupler le matériel.
  - `updateTurbine(...)` et `deleteTurbine(...)` : Maintenance et suppression.

---

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que les 3 contrats existent dans `lib/features/domain/repositories/`.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur détectée.
   - Les contrats du Domaine sont parfaitement définis et formalisés.

Passons aux services abstraits de la couche Données dans l'[Étape 11 : Couche Données — Services Abstraits](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/11_couche_donnees_services_abstraits.md).
