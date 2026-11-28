# Étape 13 : Couche Données — Implémentations des Repositories

Dans cette étape, nous implémentons concrètement les trois interfaces de repositories définies dans le Domaine :
1. `AuthenticationRepositoryImpl` : Gère le login, l'inscription, la déconnexion et la session dans `GetIt`.
2. `ProfileRepositoryImpl` : Récupère le profil du technicien connecté.
3. `TurbineRepositoryImpl` : Supervise et administre les éoliennes du parc.

---

## 1. L'implémentation `AuthenticationRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/authentication_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/authentication_repository_impl.dart) :

```dart
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/repositories/authentication_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final DbService dbService;
  Session? session;
  final getIt = GetIt.instance;

  AuthenticationRepositoryImpl({required this.dbService, this.session});

  @override
  FutureResult<dynamic> signIn({String email = "", String password = ""}) async {
    try {
      final ret = (await dbService.signIn(email: email, password: password)) as Success<String>;
      session = Session(userId: ret.value!);
      if (!getIt.isRegistered<Session>()) {
        getIt.registerSingleton<Session>(session!);
      }
      return Success();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> signOut() async {
    try {
      await dbService.signOut();
      session = null;
      if (getIt.isRegistered<Session>()) {
        getIt.unregister<Session>();
      }
      return Success();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> signUp({
    String fullName = "",
    String email = "",
    String password = "",
  }) async {
    try {
      final result = (await dbService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      )) as Success<String>;
      session = Session(userId: result.value!);
      if (!getIt.isRegistered<Session>()) {
        getIt.registerSingleton<Session>(session!);
      }
      return Success();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<bool> isSignedIn() async {
    return Success<bool>(value: session != null);
  }
}
```

### Points clés :
- Intercepte `ServerException` et retourne `Error(reason: e.reason)`.
- Enregistre `Session(userId: ...)` dans `GetIt` au succès de `signIn` ou `signUp`.
- Supprime la `Session` de `GetIt` au succès de `signOut`.
- `isSignedIn()` renvoie `Success<bool>(value: session != null)`.

---

## 2. L'implémentation `ProfileRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/profile_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/profile_repository_impl.dart) :

```dart
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/repositories/profile_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';
import 'package:windenergy/features/data/repositories/session.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final DbService dbService;

  ProfileRepositoryImpl({required this.dbService});

  @override
  FutureResult<Profile> readProfile() async {
    try {
      final session = GetIt.instance.get<Session>();
      return await dbService.readProfile(userId: session.userId);
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }
}
```

---

## 3. L'implémentation `TurbineRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/turbine_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/turbine_repository_impl.dart) :

```dart
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/features/domain/repositories/turbine_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class TurbineRepositoryImpl extends TurbineRepository {
  final DbService dbService;

  TurbineRepositoryImpl({required this.dbService});

  @override
  FutureResult<int> createTurbine({
    String serialNumber = "",
    String customName = "",
    Position position = const Position(),
  }) async {
    try {
      final session = GetIt.instance.get<Session>();
      return await dbService.createTurbine(
        userId: session.userId,
        serialNumber: serialNumber,
        customName: customName,
        position: position,
      );
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) async {
    try {
      return await dbService.deleteTurbine(turbineId: turbineId);
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<int> readCount() async {
    try {
      final session = GetIt.instance.get<Session>();
      return await dbService.readCount(userId: session.userId);
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) async {
    try {
      return await dbService.readPairingCode(turbineId: turbineId);
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<double> readTotalPowerW() async {
    try {
      final session = GetIt.instance.get<Session>();
      return await dbService.readTotalPowerW(userId: session.userId);
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> readTurbineActivation() async {
    try {
      return await dbService.readTurbineActivation();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<List<Turbine>> readTurbines() async {
    try {
      final session = GetIt.instance.get<Session>();
      return await dbService.readTurbines(userId: session.userId);
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> updateTurbine({
    int turbineId = 0,
    String customName = "",
    Position position = const Position(),
  }) async {
    try {
      return await dbService.updateTurbine(
        turbineId: turbineId,
        customName: customName,
        position: position,
      );
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }
}
```

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que les 3 implémentations existent dans `lib/features/data/repositories/`.
2. Lancez l'analyse statique :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur de compilation.
   - Les repositories sont complètement codés et prêts pour les tests unitaires.

Passons aux tests automatisés dans l'[Étape 14 : Tests Unitaires des Repositories avec Mocktail](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/14_tests_unitaires_des_repositories_avec_mocktail.md).
