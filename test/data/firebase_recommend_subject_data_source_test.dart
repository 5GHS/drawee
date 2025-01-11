import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/firebase_recommend_subject_data_source.dart';
import 'package:drawee/data/dto/recommend_subject_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('firebase recommend subject data source test', () async {
    FirebaseRecommendSubjectDataSource _dataSource =
        FirebaseRecommendSubjectDataSource(FirebaseFirestore.instance);

    RecommendSubjectDTO? result = await _dataSource.getRecommendSubject(1);
    if (result != null) {
      print(result.topic);
    }
  });
}
