import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/firebase_user_data_source.dart';
import 'package:drawee/data/data_sources/user_data_source.dart';
import 'package:drawee/data/repositories/user_repository_impl.dart';
import 'package:drawee/domain/repositories/user_repository.dart';
import 'package:drawee/domain/usecases/user/create_user_usecase.dart';
import 'package:drawee/domain/usecases/user/delete_user_usecase.dart';
import 'package:drawee/domain/usecases/user/get_user_usecase.dart';
import 'package:drawee/domain/usecases/user/update_user_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataSourceProvider = Provider<UserDataSource>((ref) {
  return FirebaseUserDataSource(FirebaseFirestore.instance);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(userDataSourceProvider));
});

final createUserUseCaseProvider = Provider<CreateUserUseCase>((ref) {
  return CreateUserUseCase(ref.watch(userRepositoryProvider));
});

final deleteUserUseCaseProvider = Provider<DeleteUserUseCase>((ref) {
  return DeleteUserUseCase(ref.watch(userRepositoryProvider));
});

final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  return GetUserUseCase(ref.watch(userRepositoryProvider));
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  return UpdateUserUseCase(ref.watch(userRepositoryProvider));
});
