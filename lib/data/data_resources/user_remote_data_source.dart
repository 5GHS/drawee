import 'package:drawee/data/data_resources/user_remote_data_source.dart';
import 'package:drawee/data/dto/user_dto.dart';
import 'package:drawee/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<UserDTO> fetchUserData(String uid) async {
    final userData = await _userDataSource.fetchUserData(uid);
    return UserDTO.fromFirestore(userData, uid);
  }
  
  @override
  Future<UserDTO?> updateUserProfile(String uid, String name) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}

class UserDataSource {
  fetchUserData(String uid) {}
}