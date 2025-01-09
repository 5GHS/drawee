import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/user_data_source.dart';
import 'package:drawee/data/dto/user_dto.dart';

class FirebaseUserDataSource implements UserDataSource {
  final FirebaseFirestore _firestore;

  FirebaseUserDataSource(this._firestore);

  @override
  Future<void> createUser(UserDTO user) async {
    final id = user.id;

    await _firestore.collection('users').doc(id).set(user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<UserDTO?> getUser(String userId) async {
    final doc = await _firestore.collection("users").doc(userId).get();
    return UserDTO.fromJson(doc.data()!, doc.id);
  }

  @override
  Future<void> updateUser(String userId, UserDTO user) async {
    await _firestore.collection('users').doc(userId).update(user.toJson());
  }
}
