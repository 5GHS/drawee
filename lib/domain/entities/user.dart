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
    String? id,
    String? imgUrl,
    String? name,
    List<String>? likedPostsIds,
    List<String>? writtenPostsIds,
  }) {
    return AppUser(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      likedPostsIds: likedPostsIds ?? this.likedPostsIds,
      name: name ?? this.name,
      writtenPostsIds: writtenPostsIds ?? this.writtenPostsIds,
    );
  }
}
