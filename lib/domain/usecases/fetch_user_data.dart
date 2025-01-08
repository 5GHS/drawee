import 'package:drawee/data/dto/user_dto.dart';
import 'package:drawee/domain/repositories/user_repository.dart';
import 'package:drawee/domain/entities/user_entity.dart';

class FetchUserData {
  final UserRepository _userRepository;

  FetchUserData(this._userRepository);

  Future<User?> call(String uid) async {
    return await _userRepository.getUserData(uid);
  }
}
