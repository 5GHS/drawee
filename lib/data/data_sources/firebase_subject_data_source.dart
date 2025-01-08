import 'package:algoliasearch/algoliasearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/data/dto/subject_dto.dart';

class FirebaseSubjectDataSource implements SubjectDataSource {
  final FirebaseFirestore _firestore;

  FirebaseSubjectDataSource(this._firestore);

  @override
  Future<List<SubjectDTO>> getSubjects(String value) async {
    try {
      final _client = SearchClient(
        appId: const String.fromEnvironment('ALGOLIA_APP_ID'),
        apiKey: const String.fromEnvironment('ALGOLIA-API_KEY'),
      );

      final response = await _firestore.collection('subjects').doc().get();
      return [];
    } catch (e) {
      return [];
    }
  }
}
