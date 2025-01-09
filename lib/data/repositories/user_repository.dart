import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/domain/repositories/user_repository.dart';

class AppUserRepositoryImpl implements AppUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> fetchUser(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return AppUser(
          id: doc.id,
          name: doc['name'],
          email: doc['email'], profile: '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
      });
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  @override
  Future<void> updateUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'email': user.email,
      });
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
