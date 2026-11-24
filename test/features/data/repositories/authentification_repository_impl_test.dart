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
      when(() => mockDbService.signIn(email: email, password: password))
          .thenAnswer((_) async => Success());
      final result = await authentifictionRepositoryImpl.signIn(
        email: email,
        password: password,
      );

      expect(result, Success());
    });

    test("should return Error", () async {
      final email = 'test@test.com';
      final password = 'pass';
      when(() => mockDbService.signIn(email: email, password: password))
          .thenThrow(ServerException());
      final result = await authentifictionRepositoryImpl.signIn(
        email: email,
        password: password,
      );

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
