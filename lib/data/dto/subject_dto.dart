import 'package:drawee/domain/entities/subject.dart';

class SubjectDTO {
  List<String> postsIds;
  String topic;
  String subjectId;

  SubjectDTO({
    required this.postsIds,
    required this.topic,
    required this.subjectId,
  });

  factory SubjectDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return SubjectDTO(
      postsIds:
          (json['postsIds'] as List<dynamic>).map((e) => e.toString()).toList(),
      topic: json['topic'],
      subjectId: documentId,
    );
  }

  Subject toEntity() {
    return Subject(topic: topic, postsIds: postsIds, subjectId: subjectId);
  }

  Map<String, dynamic> toJson() {
    return {
      'postsIds': postsIds,
      'topic': topic,
    };
  }
}
