# Étape 12 : Couche Données — Implémentations des Repositories

Dans cette étape, nous arrivons au point de jonction entre les contrats abstraits du Domaine et les services de données concrets : les **implémentations de Repositories** situées dans `lib/features/data/repositories/`.

---

## 1. Pourquoi créer les classes squelettes d'implémentation ?

Dans le développement logiciel professionnel moderne, on adopte très souvent une démarche de conception par contrat (**Contract-First Development**) :
1. On définit d'abord les interfaces (`abstract class`) pour figer le besoin métier.
2. On crée immédiatement les classes concrètes qui étendent ces interfaces (`extends AuthentificationRepository`).
3. Pour les méthodes dont le code n'est pas encore écrit, on place une instruction `throw UnimplementedError()`.

### Pourquoi `throw UnimplementedError()` ?
- Cela permet au code de **compiler immédiatement**.
- L'IDE et le compilateur vérifient que vous avez bien respecté toutes les signatures de méthodes obligatoires sans en oublier une seule.
- Si une partie de l'équipe appelle par inadvertance une méthode qui n'a pas encore été raccordée au backend, l'erreur est claire et explicite : *"Cette méthode n'a pas encore été implémentée"*.

---

## 2. L'implémentation `AuthentifictionRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/authentifiction_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/authentifiction_repository_impl.dart) :

```dart
import 'package:windenergy/features/domain/repositories/authentification_repository.dart';
import 'package:windenergy/utils/result.dart';

class AuthentifictionRepositoryImpl extends AuthentificationRepository {
  @override
  FutureResult<dynamic> signIn({String email = "", String password = ""}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> signUp({
    String fullName = "",
    String email = "",
    String password = "",
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
```

---

## 3. L'implémentation `ProfileRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/profile_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/profile_repository_impl.dart) :

```dart
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/repositories/profile_repository.dart';
import 'package:windenergy/utils/result.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  @override
  FutureResult<Profile> readProfile() {
    // TODO: implement readProfile
    throw UnimplementedError();
  }
}
```

---

## 4. L'implémentation `TurbineRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/turbine_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/turbine_repository_impl.dart) :

```dart
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/features/domain/repositories/turbine_repository.dart';
import 'package:windenergy/utils/result.dart';

class TurbineRepositoryImpl extends TurbineRepository {
  @override
  FutureResult<dynamic> createTurbine({
    String serialNumber = "",
    String customName = "",
    Position position = const Position(),
  }) {
    // TODO: implement createTurbine
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) {
    // TODO: implement deleteTurbine
    throw UnimplementedError();
  }

  @override
  FutureResult<int> readCount() {
    // TODO: implement readCount
    throw UnimplementedError();
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) {
    // TODO: implement readPairingCode
    throw UnimplementedError();
  }

  @override
  FutureResult<double> readTotalPowerW() {
    // TODO: implement readTotalPowerW
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> readTurbineActivation() {
    // TODO: implement readTurbineActivation
    throw UnimplementedError();
  }

  @override
  FutureResult<List<Turbine>> readTurbines() {
    // TODO: implement readTurbines
    throw UnimplementedError();
  }

  @override
  FutureResult<dynamic> updateTurbine({
    int turbineId = 0,
    String customName = '',
    Position position = const Position(),
  }) {
    // TODO: implement updateTurbine
    throw UnimplementedError();
  }
}
```

---

## 5. Comment ces classes fonctionneront avec l'injection de dépendances ?

Plus tard, lors de la configuration du Service Locator avec `GetIt`, vous enregistrerez vos repositories sous leur forme abstraite :

```dart
// Exemple d'injection future :
getIt.registerLazySingleton<TurbineRepository>(
  () => TurbineRepositoryImpl(dbService: getIt<DbService>()),
);
```

Grâce à cela, vos ViewModels et vos écrans demanderont un `TurbineRepository` sans jamais savoir qu'il s'agit de `TurbineRepositoryImpl`. C'est l'essence même du découplage d'architecture logicielle !

---

## 6. Attendu final

Pour valider cette étape :
1. Vérifiez que les 3 implémentations existent dans `lib/features/data/repositories/` :
   - `authentifiction_repository_impl.dart`
   - `profile_repository_impl.dart`
   - `turbine_repository_impl.dart`
2. Lancez l'analyse globale du projet dans votre terminal :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Le message `No issues found!` (ou absence d'erreurs).
   - L'ensemble des couches Domaine et Données du projet **WindEnergy** est parfaitement aligné avec la Clean Architecture et prêt à recevoir le raccordement aux services et à la couche Présentation.
