import 'package:drawee/domain/repositories/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository _repository;

  DeleteUserUseCase(this._repository);

  Future<void> execute(String userId) {
    return _repository.deleteUser(userId);
  }
}
