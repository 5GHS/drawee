import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/recommend_subject_data_source.dart';
import 'package:drawee/data/dto/recommend_subject_dto.dart';

class FirebaseRecommendSubjectDataSource implements RecommendSubjectDataSource {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseRecommendSubjectDataSource(this._firebaseFirestore);

  @override
  Future<RecommendSubjectDTO?> getRecommendSubject(int subjectIndex) async {
    final doc = await _firebaseFirestore
        .collection("recommend_subjects")
        .doc("$subjectIndex")
        .get();
    if (doc.exists) {
      return RecommendSubjectDTO.fromJson(doc.data()!, int.parse(doc.id));
    } else {
      return null;
    }
  }
}
