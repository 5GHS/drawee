import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // 사용자 정보 업데이트
  Future<void> updateUserProfile(String name, {String imgUrl = ""}) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Firebase Authentication에 이름 업데이트
        await user.updateDisplayName(name);

        // Firestore에 사용자 정보 업데이트
        await _firestore.collection('users').doc(user.uid).set({
          'name': name, // 이름
          'imgUrl': imgUrl, // 프로필 이미지 URL
          'likedPostsIds': [], // 사용자가 좋아요한 게시물 ID 목록
          'writtenPostIds': [], // 사용자가 작성한 게시물 ID 목록
        }, SetOptions(merge: true)); // 기존 데이터와 병합
      } catch (e) {
        print("Error updating user profile: $e");
        throw e;
      }
    }
  }
}