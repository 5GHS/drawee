import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class UpdateUserUseCase {
  UpdateUserUseCase(this._appUserRepository);
  final AppUserRepository _appUserRepository;

  Future<void> updateUser(AppUser user) async {
    return await _appUserRepository.updateUser(user);
  }
}