import 'package:drawee/domain/usecases/fetch_user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchUserDataProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return FetchUserData(userRepository);
});
