import 'package:drawee/data/data_sources/user_data_source.dart';
import 'package:drawee/data/dto/user_dto.dart';
import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<void> createUser(AppUser user) async {
    await _userDataSource.createUser(UserDTO.fromEntity(user));
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _userDataSource.deleteUser(userId);
  }

  @override
  Future<AppUser> getUser(String userId) async {
    final user = await _userDataSource.getUser(userId);
    return user!.toEntity();
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await _userDataSource.updateUser(user.id, UserDTO.fromEntity(user));
  }
}
