import 'package:drawee/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<User> getUser(String userId);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String userId);
}
