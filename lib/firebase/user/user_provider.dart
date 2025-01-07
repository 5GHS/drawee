import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData; // Firestore에서 가져온 사용자 데이터

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  // Firebase Authentication의 User 객체 설정
  void setUser(User? user) {
    _user = user;
    if (user != null) {
      _fetchUserData(user.uid); // Firestore에서 사용자 데이터 가져오기
    } else {
      _userData = null;
    }
    notifyListeners();
  }

  // Firestore에서 사용자 데이터 가져오기
  Future<void> _fetchUserData(String uid) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
      } else {
        _userData = {};
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _userData = {};
    }
    notifyListeners();
  }
}