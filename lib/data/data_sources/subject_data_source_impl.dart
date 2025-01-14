import 'package:algoliasearch/algoliasearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/data/dto/subject_dto.dart';

class SubjectDataSourceImpl implements SubjectDataSource {
  final FirebaseFirestore _firestore;

  SubjectDataSourceImpl(this._firestore);

  // firebase에서 subjectId로 조회
  @override
  Future<SubjectDTO?> getSubject(String subjectId) async {
    try {
      final doc = await _firestore.collection('subjects').doc(subjectId).get();
      if (doc.exists) {
        return SubjectDTO.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return null;
    }
  }

  // algolia에서 검색어로 조회
  @override
  Future<List<SubjectDTO>> getSubjects(String query) async {
    try {
      final _client = SearchClient(
        appId: const String.fromEnvironment('ALGOLIA_APP_ID'),
        apiKey: const String.fromEnvironment('ALGOLIA_API_KEY'),
      );

      final queryHits = SearchForHits(
        indexName: 'subjects',
        query: query,
        hitsPerPage: 10,
      );

      final snapshot = await _client.searchIndex(request: queryHits);

      return snapshot.hits
          .map((hit) => SubjectDTO.fromJson(hit, hit.objectID))
          .toList();
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return [];
    }
  }

  @override
  Future<void> createSubject(String topic) async {
    try {
      final subjectRef = await _firestore.collection('subjects').doc();
      final String id = subjectRef.id;
      await subjectRef.set({
        'subjectId': id,
        'topic': topic,
        'postsIds': [],
      });

      final _client = SearchClient(
        appId: const String.fromEnvironment('ALGOLIA_APP_ID'),
        apiKey: const String.fromEnvironment('ALGOLIA_API_KEY'),
      );

      await _client.addOrUpdateObject(
        indexName: 'subjects',
        objectID: id,
        body: {
          'subjectId': id,
          'topic': topic,
          'postsIds': [],
        },
      );
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }
}
