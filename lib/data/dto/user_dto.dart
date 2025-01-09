import 'package:drawee/domain/entities/user.dart';

class UserDTO {
  final String id;
  final String imgUrl;
  final List<String> likedPostsIds;
  final String name;
  final List<String> writtenPostsIds;

  UserDTO({
    required this.id,
    required this.imgUrl,
    required this.likedPostsIds,
    required this.name,
    required this.writtenPostsIds,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return UserDTO(
      id: documentId,
      imgUrl: json['imgUrl'] as String,
      likedPostsIds: List<String>.from(json['likedPostsIds'] as List),
      name: json['name'] as String,
      writtenPostsIds: List<String>.from(json['writtenPostsIds'] as List),
    );
  }
  Map<String, dynamic> toJson() {
    // id는 제외 -> firestore에서 자동 생성!!!!
    return {
      'imgUrl': imgUrl,
      'likedPostsIds': likedPostsIds,
      'name': name,
      'writtenPostsIds': writtenPostsIds,
    };
  }

  AppUser toEntity() {
    return AppUser(
      id: id,
      imgUrl: imgUrl,
      likedPostsIds: likedPostsIds,
      name: name,
      writtenPostsIds: writtenPostsIds,
    );
  }

  factory UserDTO.fromEntity(AppUser user) {
    return UserDTO(
      id: user.id,
      imgUrl: user.imgUrl,
      likedPostsIds: user.likedPostsIds,
      name: user.name,
      writtenPostsIds: user.writtenPostsIds,
    );
  }
}
