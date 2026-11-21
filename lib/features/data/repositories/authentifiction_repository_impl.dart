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
