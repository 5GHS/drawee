class AppUser {
  final String id;
  final String imgUrl;
  final List<String> likedPostsIds;
  final String name;
  final List<String> writtenPostsIds;

  const AppUser({
    required this.id,
    required this.imgUrl,
    required this.likedPostsIds,
    required this.name,
    required this.writtenPostsIds,
  });
}
