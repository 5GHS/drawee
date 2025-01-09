import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository _repository;

  UpdateUserUseCase(this._repository);

  Future<void> execute(AppUser user) {
    return _repository.updateUser(user);
  }
}
