import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 사용자 프로필 업데이트
  Future<Map<String, dynamic>?> updateUserProfile(String name) async {
    if (name.isEmpty) {
      throw ArgumentError("Name cannot be empty.");
    }

    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Firebase Authentication에 이름 업데이트
        await user.updateDisplayName(name);

        // Firestore에 사용자 정보 업데이트
        Map<String, dynamic> updatedData = {
          'name': name,
          'email': user.email,
          'uid': user.uid,
        };
        await _firestore.collection('users').doc(user.uid).set(
              updatedData,
              SetOptions(merge: true),
            );

        print('User profile updated successfully.');
        return updatedData; // 업데이트된 데이터 반환
      } catch (e) {
        print("Error updating user profile: $e");
        throw e;
      }
    } else {
      print('No user is logged in.');
      return null;
    }
  }
}