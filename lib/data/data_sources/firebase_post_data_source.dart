import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/post_data_source.dart';
import 'package:drawee/data/dto/post_dto.dart';

class FirebasePostDataSource implements PostDataSource {
  final FirebaseFirestore _firestore;

  FirebasePostDataSource(this._firestore);

  @override
  Future<PostDTO?> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return PostDTO.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<PostDTO>> getPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PostDTO.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<PostDTO>> getPostsByWeather(String weather) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('weather', isEqualTo: weather)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => PostDTO.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<bool> createPost(Map<String, dynamic> data) async {
    try {
      final docRef = _firestore.collection('posts').doc();
      await docRef.set(data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updatePost(String postId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('posts').doc(postId).update(data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<PostDTO>> getPostsBySubjectId(String subjectId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => PostDTO.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<PostDTO>> getPostsByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => PostDTO.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<PostDTO>> getPostsByIds(List<String> postIds) async {
    final snapshot = await _firestore
        .collection('posts')
        .where(FieldPath.documentId, whereIn: postIds)
        .get();
    return snapshot.docs
        .map((doc) => PostDTO.fromJson(doc.data(), doc.id))
        .toList();
  }
}
