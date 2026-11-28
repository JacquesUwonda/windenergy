# Étape 14 : Tests Unitaires des Repositories avec Mocktail

Dans cette étape, nous allons tester unitairement nos Repositories sans aucune connexion réseau ni serveur réel, grâce au package **`mocktail`**.

---

## 1. Pourquoi tester unitairement avec des Mocks ?

- Un test unitaire doit s'exécuter en quelques millisecondes et être déterministe (toujours donner le même résultat).
- En simulant `DbService` avec un Mock (`MockDbService extends Mock implements DbService {}`), nous pouvons programmer précisément le comportement souhaité :
  - **Cas nominal** : `when(() => mockDbService.methode()).thenAnswer((_) async => Success(...))`
  - **Cas d'erreur** : `when(() => mockDbService.methode()).thenThrow(ServerException())`
- Cela permet de vérifier que nos Repositories orchestrent correctement la session et interceptent fidèlement les exceptions.

---

## 2. Test : `AuthenticationRepositoryImpl`

Créez le fichier [test/features/data/repositories/authentication_repository_impl_test.dart](file:///d:/PROJECT2026/windenergy/test/features/data/repositories/authentication_repository_impl_test.dart) :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:windenergy/features/data/repositories/authentication_repository_impl.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class MockDbService extends Mock implements DbService {}

void main() {
  late MockDbService mockDbService;
  late AuthenticationRepositoryImpl authenticationRepositoryImpl;

  setUp(() {
    mockDbService = MockDbService();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl(
      dbService: mockDbService,
    );
  });

  group("signIn", () {
    test("should return Success", () async {
      final email = "test@test.com";
      final password = "pass";
      when(() => mockDbService.signIn(email: email, password: password))
          .thenAnswer((_) async => Success<String>(value: "<<"));
      final result = await authenticationRepositoryImpl.signIn(
        email: email,
        password: password,
      );
      expect(result, Success());
    });

    test("should return Error", () async {
      final email = "test@test.com";
      final password = "pass";
      when(() => mockDbService.signIn(email: email, password: password))
          .thenThrow(ServerException());
      final result = await authenticationRepositoryImpl.signIn(
        email: email,
        password: password,
      );
      expect(result, Error());
    });
  });

  group("signUp", () {
    test("should return Success", () async {
      final email = "test@test.com";
      final fullName = "test";
      final password = "pass";
      when(
        () => mockDbService.signUp(
          email: email,
          fullName: fullName,
          password: password,
        ),
      ).thenAnswer((_) async => Success<String>(value: ""));
      final result = await authenticationRepositoryImpl.signUp(
        email: email,
        fullName: fullName,
        password: password,
      );
      expect(result, Success());
    });

    test("should return Error", () async {
      final email = "test@test.com";
      final fullName = "test";
      final password = "pass";
      when(
        () => mockDbService.signUp(
          email: email,
          fullName: fullName,
          password: password,
        ),
      ).thenThrow(ServerException());
      final result = await authenticationRepositoryImpl.signUp(
        email: email,
        fullName: fullName,
        password: password,
      );
      expect(result, Error());
    });
  });

  group("signOut", () {
    test("should return Success", () async {
      when(() => mockDbService.signOut()).thenAnswer((_) async => Success());
      final result = await authenticationRepositoryImpl.signOut();
      expect(result, Success());
    });

    test("should return Error", () async {
      when(() => mockDbService.signOut()).thenThrow(ServerException());
      final result = await authenticationRepositoryImpl.signOut();
      expect(result, Error());
    });
  });

  group("isSignedIn", () {
    test("should return Success", () async {
      final result = await authenticationRepositoryImpl.isSignedIn();
      expect(result, Success<bool>(value: false));
    });
  });
}
```

---

## 3. Test : `ProfileRepositoryImpl`

Créez le fichier [test/features/data/repositories/profile_repository_impl_test.dart](file:///d:/PROJECT2026/windenergy/test/features/data/repositories/profile_repository_impl_test.dart) :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:windenergy/features/data/repositories/profile_repository_impl.dart';
import 'package:windenergy/features/data/repositories/session.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class MockDbService extends Mock implements DbService {}

void main() {
  late MockDbService mockDbService;
  late ProfileRepositoryImpl profileRepositoryImpl;

  setUp(() {
    mockDbService = MockDbService();
    profileRepositoryImpl = ProfileRepositoryImpl(dbService: mockDbService);
    if (!GetIt.instance.isRegistered<Session>()) {
      GetIt.instance.registerSingleton<Session>(Session(userId: "0"));
    }
  });

  group("readProfile", () {
    test("should return Success", () async {
      when(() => mockDbService.readProfile(userId: "0"))
          .thenAnswer((_) async => Success());
      final result = await profileRepositoryImpl.readProfile();
      expect(result, Success<Profile>());
    });

    test("should return Error", () async {
      when(() => mockDbService.readProfile(userId: "0"))
          .thenThrow(ServerException());
      final result = await profileRepositoryImpl.readProfile();
      expect(result, Error<Profile>());
    });
  });
}
```

---

## 4. Test : `TurbineRepositoryImpl`

Ouvrez le fichier [test/features/data/repositories/turbine_repository_impl_test.dart](file:///d:/PROJECT2026/windenergy/test/features/data/repositories/turbine_repository_impl_test.dart).
Il teste l'ensemble des opérations (`createTurbine`, `deleteTurbine`, `readCount`, `readPairingCode`, `readTotalPowerW`, `readTurbines`, `updateTurbine`) à la fois pour le cas de succès et le cas d'erreur `ServerException`.

---

## 5. Attendu final

Pour valider cette étape :
1. Lancez la suite de tests :
   ```bash
   flutter test
   ```
2. **Ce que vous devez observer :**
   - Tous les tests s'exécutent et passent au vert (`All tests passed!`).
   - Vos repositories sont fiables et robustes face aux pannes réseau.

Vous avez validé le **Jour 3** ! Passons au **Jour 4** avec la mise en place du backend Supabase et de la base SQL.
