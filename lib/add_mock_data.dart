import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Weather Enum
enum Weather { sunny, rainy, cloudy, windy, snowy }

// User Entity
class User {
  final String userId;
  final String name;
  final List<String> writtenPostIds; // 작성한 글의 postId만 저장
  final List<String> likedPostIds; // 좋아요 누른 글의 postId만 저장
  final String imgUrl;

  User({
    required this.userId,
    required this.name,
    required this.writtenPostIds,
    required this.likedPostIds,
    required this.imgUrl,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'writtenPostIds': writtenPostIds,
      'likedPostIds': likedPostIds,
      'imgUrl': imgUrl,
    };
  }
}

// Post Entity (User 객체를 직접 보관)
class Post {
  final String postId;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String subject;
  final Weather weather;
  final List<String> commentIds;
  final User user; // userId 대신 User 객체 전체를 저장
  final int likes;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.subject,
    required this.weather,
    required this.commentIds,
    required this.user,
    required this.likes,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'subject': subject,
      'weather': weather.name,
      'commentIds': commentIds,
      // user 필드에 중첩 객체로 User 정보를 저장
      'user': user.toFirestore(),
      'likes': likes,
    };
  }
}

// Comment Entity
class Comment {
  final String commentId;
  final String content;
  final DateTime createdAt;
  final String userId;

  Comment({
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'commentId': commentId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }
}

// Mock Data Upload Function
Future<void> addMockData() async {
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;
  final random = Random();

  final weatherOptions = Weather.values;

  // 사용자 이름 후보
  List<String> userNames = [
    '겨울이',
    '돌멩이',
    '고무대야',
    '김장김치',
    '임연수구이',
    '치즈계란말이',
    '감자전',
    '봉오동',
    '캔디팝팝',
    '캔따개',
    '루피',
    '고무고무',
    '후크선장',
    '팅커벨',
    '아티스트',
    '링딩동',
    '청댬둉',
    '불국사',
    '해인사팔만대장경',
    '강아지풀'
  ];

  // 1) Users 생성 (in memory)
  List<User> users = [];
  for (int i = 0; i < 20; i++) {
    final userDocRef = firestore.collection('users').doc();

    final user = User(
      userId: userDocRef.id,
      name: userNames[random.nextInt(userNames.length)],
      writtenPostIds: [],
      likedPostIds: [],
      imgUrl: 'https://picsum.photos/id/$i/200/',
    );
    users.add(user);
  }

  // 2) Posts 생성 (in memory)
  List<Post> posts = [];
  for (int i = 0; i < 100; i++) {
    final randomUser = users[random.nextInt(users.length)];
    final postDocRef = firestore.collection('posts').doc();

    final post = Post(
      postId: postDocRef.id,
      title: '오늘의 그림 일기 ${random.nextInt(1000)}',
      content: '일기를 써보겠습니다. 두근두근',
      imageUrl: 'https://picsum.photos/id/${random.nextInt(1000)}/200/',
      createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      subject: 'Subject ${random.nextInt(100)}',
      weather: weatherOptions[random.nextInt(weatherOptions.length)],
      commentIds: [],
      user: randomUser, // user 객체 전체를 보관
      likes: random.nextInt(100),
    );

    // 해당 user가 작성한 글 목록(writtenPostIds)에 postId 추가
    randomUser.writtenPostIds.add(post.postId);

    posts.add(post);
  }

  // 3) Comments 생성 (in memory) - 총 200개의 댓글
  List<Comment> comments = [];
  for (int i = 0; i < 200; i++) {
    final randomPost = posts[random.nextInt(posts.length)];
    final randomUser = users[random.nextInt(users.length)];
    final commentDocRef = firestore.collection('comments').doc();

    final comment = Comment(
      commentId: commentDocRef.id,
      content: '그림이 멋지네요!',
      createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      userId: randomUser.userId,
    );

    // 해당 post가 가진 commentIds에 이 comment의 ID를 추가
    randomPost.commentIds.add(comment.commentId);

    comments.add(comment);
  }

  // 4) Firestore 업로드
  // (1) Users 업로드 (병렬)
  await Future.wait(users.map((user) {
    return firestore
        .collection('users')
        .doc(user.userId)
        .set(user.toFirestore());
  }));
  print('Users uploaded.');

  // (2) Posts 업로드 (병렬)
  await Future.wait(posts.map((post) {
    return firestore
        .collection('posts')
        .doc(post.postId)
        .set(post.toFirestore());
  }));
  print('Posts uploaded.');

  // (3) Comments 업로드 (병렬)
  await Future.wait(comments.map((comment) {
    return firestore
        .collection('comments')
        .doc(comment.commentId)
        .set(comment.toFirestore());
  }));
  print('Comments uploaded.');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await addMockData();
}
