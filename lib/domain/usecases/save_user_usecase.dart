import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class SaveUserUseCase {
  SaveUserUseCase(this._appUserRepository);
  final AppUserRepository _appUserRepository;

  Future<void> saveUser(AppUser user) async {
    return await _appUserRepository.saveUser(user);
  }
}