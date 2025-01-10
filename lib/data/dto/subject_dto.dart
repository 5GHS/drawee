import 'package:drawee/domain/entities/subject.dart';

class SubjectDTO {
  List<String> postsIds;
  String topic;

  SubjectDTO({
    required this.postsIds,
    required this.topic,
  });

  SubjectDTO.fromJson(Map<String, dynamic> json)
      : this(
          postsIds:
              (json['postsIds'] as List).map((item) => item as String).toList(),
          topic: json['topic'],
        );

  Subject toEntity() {
    return Subject(topic: topic, postsIds: postsIds);
  }

  Map<String, dynamic> toJson() {
    return {
      'postsIds': postsIds,
      'topic': topic,
    };
  }
}
