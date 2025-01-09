import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<AppUser> execute(String userId) {
    return _repository.getUser(userId);
  }
}
