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

  AppUser copyWith({
    String? imgUrl,
  }) {
    return AppUser(
      id: id,
      imgUrl: imgUrl ?? this.imgUrl,
      likedPostsIds: likedPostsIds,
      name: name,
      writtenPostsIds: writtenPostsIds,
    );
  }
}
