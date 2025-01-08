import 'package:drawee/data/data_resources/user_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepository(this._remoteDataSource);

  // 현재 로그인한 사용자 가져오기
  Future<User?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  // 사용자 데이터 가져오기
  Future<Map<String, dynamic>> fetchUserData(String uid) async {
    return _remoteDataSource.(String uid) async {}(uid);
  }

  // 사용자 프로필 업데이트
  Future<Map<String, dynamic>?> updateUserProfile(String name, String imgUrl) {
    return _remoteDataSource.updateUserProfile(name);
  }
}

class UserRemoteDataSource {
  updateUserProfile(String name) {}
  
  Future<User?> getCurrentUser() async {}
}
