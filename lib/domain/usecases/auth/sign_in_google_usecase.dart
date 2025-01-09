import 'package:drawee/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInGoogleUsecase {
  final AuthRepository _authRepository;

  SignInGoogleUsecase(this._authRepository);

  Future<User?> execute() {
    return _authRepository.signInWithGoogle();
  }
}
