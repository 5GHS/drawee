import 'package:drawee/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<AppUser> getUser(String userId);
  Future<void> createUser(AppUser user);
  Future<void> updateUser(AppUser user);
  Future<void> deleteUser(String userId);
}
