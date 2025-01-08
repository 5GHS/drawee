import 'package:drawee/domain/entities/user_entity.dart';
import 'package:drawee/data/dto/user_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';


abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<UserDTO> fetchUserData(String uid);
  Future<UserDTO?> updateUserProfile(String uid, String name);
}