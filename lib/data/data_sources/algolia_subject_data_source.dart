import 'package:algoliasearch/algoliasearch.dart';
import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/data/dto/subject_dto.dart';

class AlgoliaSubjectDataSource implements SubjectDataSource {
  AlgoliaSubjectDataSource();

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

      final response = await _client.searchIndex(request: queryHits);

      if (response.hits.isNotEmpty) {
        final iterable = List.from(response.hits)
            .map((element) => SubjectDTO.fromJson(element));
        return iterable.toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
