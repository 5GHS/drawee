import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class FetchUserUseCase {
  FetchUserUseCase(this._appUserRepository);
  final AppUserRepository _appUserRepository;

  Future<AppUser?> fetchUser(String id) async {
    return await _appUserRepository.fetchUser(id);
  }
}