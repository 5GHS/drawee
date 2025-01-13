import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/firebase_post_data_source.dart';
import 'package:drawee/data/repositories/post_repository_impl.dart';
import 'package:drawee/domain/entities/post.dart';

void main() async {
  final postRepo = PostRepositoryImpl(
    FirebasePostDataSource(FirebaseFirestore.instance),
  );
  final result = await postRepo.createPost(
    Post(
      title: 'test',
      content: 'test',
      subjectId: '123',
      userId: '123',
      weather: 'sunny',
      createdAt: DateTime.now(),
      imageUrl: 'test',
      likes: 0,
      comments: [],
      postId: '123',
    ),
  );
  print('Post creation ${result ? "succeeded" : "failed"}');
}
