import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 인증 상태 스트림
  Stream<User?> get user => _auth.authStateChanges();

  // 구글 로그인
  Future<User?> signInWithGoogle() async {
    try {
      // (구글 로그인 코드 생략)
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 사용자 이름과 프로필 사진 업데이트
  Future<void> updateUserProfile(String name, String? profileImagePath) async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Firebase Authentication에 이름 업데이트
      try {
        await user.updateDisplayName(name);

        // 프로필 사진 업데이트
        String? photoUrl;
        if (profileImagePath != null) {
          // 프로필 이미지 업로드
          File profileImageFile = File(profileImagePath);
          String fileName = 'profile_pictures/${user.uid}.jpg';
          TaskSnapshot snapshot = await _storage.ref().child(fileName).putFile(profileImageFile);
          photoUrl = await snapshot.ref.getDownloadURL();
          await user.updatePhotoURL(photoUrl);
        }

        // Firestore에 사용자 정보 업데이트
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': user.email,
          'photoUrl': photoUrl ?? user.photoURL,
          'uid': user.uid,
        }, SetOptions(merge: true)); // 기존 데이터와 병합
      } catch (e) {
        print("Error updating user profile: $e");
        throw e;
      }
    }
  }
}