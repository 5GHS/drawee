import 'package:drawee/domain/entities/recommend_subject.dart';
import 'package:flutter/material.dart';

class RecommendSubjectDTO {
  int subjectIndex;
  String subjectId;
  String topic;

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
