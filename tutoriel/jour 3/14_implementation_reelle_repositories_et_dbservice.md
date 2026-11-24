# Étape 14 : Implémentation réelle des Repositories et Délégation à DbService

À l'étape 12, nous avions mis en place les classes squelettes de nos repositories avec `throw UnimplementedError()`. Maintenant que nous avons notre abstraction de base de données `DbService` et notre exception technique `ServerException`, nous allons écrire l'implémentation réelle de nos 3 repositories.

---

## 1. Quel est le rôle exact d'un Repository en Clean Architecture ?

Le **Repository** est un médiateur (ou adaptateur métier) :
1. Il reçoit l'appel du ViewModel (ex: `createTurbine(...)`).
2. Il transmet l'ordre au service technique approprié (`DbService`).
3. Il intercepte les exceptions techniques éventuelles (`on ServerException catch (e)`).
4. Il traduit l'issue de l'opération en un résultat métier propre (`Success` ou `Error(reason: e.reason)`).

Le reste de l'application n'a ainsi jamais besoin de faire de `try/catch` : le Repository garantit que l'appel renverra toujours un `Result<T>` exploitable en toute sécurité.

---

## 2. Implémentation de `AuthentificationRepositoryImpl`

Ouvrez ou créez le fichier [lib/features/data/repositories/authentification_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/authentification_repository_impl.dart) :

```dart
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/repositories/authentification_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class AuthentifictionRepositoryImpl extends AuthentificationRepository {
  final DbService dbService;

  AuthentifictionRepositoryImpl({required this.dbService});

  @override
  FutureResult<dynamic> signIn({
    String email = "",
    String password = "",
  }) async {
    try {
      return await dbService.signIn(email: email, password: password);
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
      return await dbService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
    } catch (e) {
      return Error(reason: "some error has occurred");
    }
  }

  @override
  FutureResult<dynamic> signOut() async {
    try {
      return await dbService.signOut();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }
}
```

### Analyse pédagogique :
- **Injection par constructeur** : `AuthentifictionRepositoryImpl({required this.dbService});`. Le repository ne crée pas lui-même le `DbService` avec un `new`. Il le reçoit en paramètre. Cela permet de lui injecter un faux `DbService` (un mock) lors des tests unitaires !
- **Protection par `try / on ServerException`** : Si le serveur d'authentification tombe ou renvoie une erreur de mot de passe incorrect sous forme de `ServerException`, la méthode retourne élégamment `Error(reason: e.reason)`.

---

## 3. Implémentation de `ProfileRepositoryImpl`

Ouvrez le fichier [lib/features/data/repositories/profile_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/profile_repository_impl.dart) :

```dart
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/repositories/profile_repository.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final DbService dbService;

  ProfileRepositoryImpl({required this.dbService});

  @override
  FutureResult<Profile> readProfile() async {
    try {
      return await dbService.readProfile();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }
}
```

---

## 4. Implémentation de `TurbineRepositoryImpl`

Ouvrez le fichier [lib/features/data/repositories/turbine_repository_impl.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/repositories/turbine_repository_impl.dart) :

```dart
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
  FutureResult<dynamic> createTurbine({
    String serialNumber = "",
    String customName = "",
    Position position = const Position(),
  }) async {
    try {
      return await dbService.createTurbine(
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
      return await dbService.readCount();
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
      return await dbService.readTotalPowerW();
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
      return await dbService.readTurbines();
    } on ServerException catch (e) {
      return Error(reason: e.reason);
    }
  }

  @override
  FutureResult<dynamic> updateTurbine({
    int turbineId = 0,
    String customName = '',
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

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que les 3 repositories dans `lib/features/data/repositories/` sont bien à jour et intègrent l'injection de `DbService`.
2. Lancez l'analyse du projet :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur de compilation.
   - Les 3 repositories sont complètement implémentés et prêts à être testés unitairement sans dépendre d'une vraie base de données active.

Passons aux tests unitaires dans l'[Étape 15 : Tests unitaires des Repositories avec Mocktail](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/15_tests_unitaires_repositories_avec_mocktail.md).
