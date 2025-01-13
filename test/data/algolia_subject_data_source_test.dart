import 'package:drawee/data/data_sources/algolia_subject_data_source.dart';
import 'package:drawee/data/dto/subject_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('algolia subject data source test', () async {
    AlgoliaSubjectDataSource _datasource = AlgoliaSubjectDataSource();

    List<SubjectDTO> list = await _datasource.getSubjects('겨울');
    expect(list.isNotEmpty, true);
    print(list[0].topic);
    print(list[0].postsIds);
  });
}
