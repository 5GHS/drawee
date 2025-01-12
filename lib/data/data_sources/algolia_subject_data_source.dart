import 'package:algoliasearch/algoliasearch.dart';
import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/data/dto/subject_dto.dart';

class AlgoliaSubjectDataSource implements SubjectDataSource {
  AlgoliaSubjectDataSource();

  @override
  Future<SubjectDTO?> getSubject(String query) async {
    try {
      final _client = SearchClient(
        appId: const String.fromEnvironment('ALGOLIA_APP_ID'),
        apiKey: const String.fromEnvironment('ALGOLIA_API_KEY'),
      );

      final queryHits = SearchForHits(
        indexName: 'subjects',
        query: query,
        hitsPerPage: 1,
      );

      final snapshot = await _client.searchIndex(request: queryHits);

      if (snapshot.hits.isNotEmpty) {
        return SubjectDTO.fromJson(snapshot.hits.first);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

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

      return snapshot.hits.map((hit) => SubjectDTO.fromJson(hit)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
