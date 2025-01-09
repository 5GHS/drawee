import 'package:drawee/data/dto/user_dto.dart';

abstract interface class UserDataSource {
  Future<UserDTO?> getUser(String userId);
  Future<void> createUser(UserDTO user);
  Future<void> updateUser(String userId, UserDTO user);
  Future<void> deleteUser(String userId);
}
