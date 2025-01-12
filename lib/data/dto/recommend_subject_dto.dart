import 'package:drawee/domain/entities/recommend_subject.dart';

class RecommendSubjectDTO {
  int subjectIndex; // 날짜와 일치하는 추천 주제의 인덱스
  String subjectId; // 주제 ID
  String topic; // 주제

  RecommendSubjectDTO({
    required this.subjectIndex,
    required this.subjectId,
    required this.topic,
  });

  factory RecommendSubjectDTO.fromJson(
      Map<String, dynamic> json, int documentId) {
    return RecommendSubjectDTO(
      subjectIndex: documentId,
      subjectId: json['subjectId'],
      topic: json['topic'],
    );
  }

  RecommendSubject toEntity() {
    return RecommendSubject(
      subjectIndex: subjectIndex,
      subjectId: subjectId,
      topic: topic,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'topic': topic,
    };
  }
}
