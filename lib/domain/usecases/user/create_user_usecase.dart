import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository _repository;

  CreateUserUseCase(this._repository);

  Future<void> execute(AppUser user) {
    return _repository.createUser(user);
  }
}
