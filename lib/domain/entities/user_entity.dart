class UserEntity {
  final String id;
  final String name;
  final String imgUrl;
  final List<String> likedPostsIds;
  final List<String> writtenPostIds;

  UserEntity({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.likedPostsIds,
    required this.writtenPostIds,
  });
}