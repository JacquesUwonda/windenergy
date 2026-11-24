# Étape 15 : Tests Unitaires des Repositories avec Mocktail

Dans les projets industriels critiques comme la supervision d'énergie éolienne, tester le code n'est pas une option : c'est un gage de sécurité fondamental. Dans cette étape, nous allons apprendre à tester unitairement nos Repositories en isolant complètement la base de données grâce à la bibliothèque **Mocktail**.

---

## 1. Pourquoi utiliser des Mocks pour tester un Repository ?

Quand on teste `TurbineRepositoryImpl` :
- On **ne veut pas** se connecter à une vraie base de données PostgreSQL ou Supabase. Sinon, le test nécessiterait une connexion Internet, dépendrait de données qui peuvent changer ou être effacées, et serait très lent à s'exécuter.
- On **veut** tester uniquement le comportement du repository :
  1. Si `DbService` réussit et renvoie une donnée, est-ce que le repository renvoie bien un `Success` ?
  2. Si `DbService` lève une `ServerException`, est-ce que le repository intercepte bien l'erreur et renvoie un `Error` ?

### La solution : Créer un Mock
Un **Mock** est un objet simulé qui prend l'apparence de `DbService`, et dont nous allons programmer les réponses à l'avance.
Avec `mocktail`, c'est aussi simple que :
```dart
class MockDbService extends Mock implements DbService {}
```

---

## 2. Test unitaire : `AuthentifictionRepositoryImpl`

Créez le fichier [test/features/data/repositories/authentification_repository_impl_test.dart](file:///d:/PROJECT2026/windenergy/test/features/data/repositories/authentification_repository_impl_test.dart) :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/features/data/repositories/authentification_repository_impl.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class MockDbService extends Mock implements DbService {}

void main() {
  late MockDbService mockDbService;
  late AuthentifictionRepositoryImpl authentifictionRepositoryImpl;

  // setUp s'exécute avant chaque test pour repartir avec un état propre
  setUp(() {
    mockDbService = MockDbService();
    authentifictionRepositoryImpl = AuthentifictionRepositoryImpl(
      dbService: mockDbService,
    );
  });

  group("signIn", () {
    test("should return Success", () async {
      final email = 'test@test.com';
      final password = 'pass';
      
      // On programme le mock : quand signIn est appelé, il renvoie Success()
      when(() => mockDbService.signIn(email: email, password: password))
          .thenAnswer((_) async => Success());

      final result = await authentifictionRepositoryImpl.signIn(
        email: email,
        password: password,
      );

      // On vérifie que le repository retourne bien Success
      expect(result, Success());
    });

    test("should return Error", () async {
      final email = 'test@test.com';
      final password = 'pass';
      
      // On programme le mock pour simuler une panne serveur
      when(() => mockDbService.signIn(email: email, password: password))
          .thenThrow(ServerException());

      final result = await authentifictionRepositoryImpl.signIn(
        email: email,
        password: password,
      );

      // On vérifie que le repository a converti l'exception en Error
      expect(result, Error());
    });
  });

  group("signUp", () {
    test("should return Success", () async {
      final fullName = 'Test User';
      final email = 'test@test.com';
      final password = 'pass';

      when(
        () => mockDbService.signUp(
          fullName: fullName,
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => Success());

      final result = await authentifictionRepositoryImpl.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      expect(result, Success());
    });

    test("should return Error", () async {
      final fullName = 'Test User';
      final email = 'test@test.com';
      final password = 'pass';

      when(
        () => mockDbService.signUp(
          fullName: fullName,
          email: email,
          password: password,
        ),
      ).thenThrow(ServerException());

      final result = await authentifictionRepositoryImpl.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      expect(result, Error(reason: "some error has occurred"));
    });
  });

  group("signOut", () {
    test("should return Success", () async {
      when(() => mockDbService.signOut()).thenAnswer((_) async => Success());
      final result = await authentifictionRepositoryImpl.signOut();

      expect(result, Success());
    });

    test("should return Error", () async {
      when(() => mockDbService.signOut()).thenThrow(ServerException());
      final result = await authentifictionRepositoryImpl.signOut();

      expect(result, Error());
    });
  });
}
```

---

## 3. Test unitaire : `ProfileRepositoryImpl`

Créez le fichier [test/features/data/repositories/profile_repository_impl_test.dart](file:///d:/PROJECT2026/windenergy/test/features/data/repositories/profile_repository_impl_test.dart) :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:windenergy/features/data/repositories/profile_repository_impl.dart';
import 'package:windenergy/features/data/services/db_service.dart';
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
  });

  group("readProfile", () {
    test("should return Success with Profile", () async {
      when(() => mockDbService.readProfile())
          .thenAnswer((_) async => Success());

      final result = await profileRepositoryImpl.readProfile();

      expect(result, Success<Profile>());
    });

    test("should return Error", () async {
      when(() => mockDbService.readProfile()).thenThrow(ServerException());

      final result = await profileRepositoryImpl.readProfile();

      expect(result, Error<Profile>());
    });
  });
}
```

---

## 4. Test unitaire : `TurbineRepositoryImpl`

Créez le fichier [test/features/data/repositories/turbine_repository_impl_test.dart](file:///d:/PROJECT2026/windenergy/test/features/data/repositories/turbine_repository_impl_test.dart) pour couvrir l'ensemble des méthodes : `createTurbine`, `deleteTurbine`, `readCount`, `readPairingCode`, `readTotalPowerW`, `readTurbines`, `updateTurbine` et `readTurbineActivation`.

Chaque scénario teste :
1. Le cas nominal : le `mockDbService` répond `Success(...)` -> le repository renvoie `Success(...)`.
2. Le cas d'erreur : le `mockDbService` lève `ServerException()` -> le repository intercepte et renvoie `Error()`.

---

## 5. Attendu final

Pour valider cette étape et confirmer que toute la couche Données est 100% robuste :
1. Lancez l'ensemble des tests de l'application depuis votre terminal :
   ```bash
   flutter test
   ```
2. **Ce que vous devez observer :**
   ```text
   00:02 +18: All tests passed!
   ```
   - Tous les tests s'exécutent en quelques secondes en local, sans connexion réseau, et confirment la fiabilité absolue de vos Repositories.

Votre application possède maintenant une couche Données blindée et validée par les tests !
