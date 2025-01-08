class UserDTO {
  final String uid;
  final String name;
  final String imgUrl;
  final List<String> likedPostsIds;
  final List<String> writtenPostIds;

  UserDTO({
    required this.uid,
    required this.name,
    required this.imgUrl,
    required this.likedPostsIds,
    required this.writtenPostIds,
  });

  // Firestore에서 가져온 데이터를 DTO로 변환
  factory UserDTO.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserDTO(
      uid: uid,
      name: data['name'] ?? 'Unknown User',
      imgUrl: data['imgUrl'] ?? '',
      likedPostsIds: List<String>.from(data['likedPostsIds'] ?? []),
      writtenPostIds: List<String>.from(data['writtenPostIds'] ?? []),
    );
  }

  // DTO에서 Firestore에 저장할 데이터로 변환
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imgUrl': imgUrl,
      'likedPostsIds': likedPostsIds,
      'writtenPostIds': writtenPostIds,
    };
  }
}