import 'package:drawee/data/data_sources/auth_data_source.dart';
import 'package:drawee/data/data_sources/firebase_auth_data_source.dart';
import 'package:drawee/data/repositories/auth_repository_impl.dart';
import 'package:drawee/domain/repositories/auth_repository.dart';
import 'package:drawee/domain/usecases/auth/sign_in_google_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return FirebaseAuthDataSource(FirebaseAuth.instance);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

final signInGoogleUsecaseProvider = Provider<SignInGoogleUsecase>((ref) {
  return SignInGoogleUsecase(ref.read(authRepositoryProvider));
});
