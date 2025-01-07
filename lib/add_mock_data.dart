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

class AddMockData extends StatelessWidget {
  const AddMockData({super.key});

  Future<void> addMockData() async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    final random = Random();

    const weatherOptions = Weather.values;
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

    // 1) User 데이터 생성
    List<User> users = List.generate(20, (i) {
      return User(
        userId: 'user_$i',
        name: userNames[random.nextInt(userNames.length)],
        writtenPostIds: [],
        likedPostIds: [],
        imgUrl: 'https://picsum.photos/id/$i/200/',
      );
    });

    // 2) Post 데이터 생성
    List<Post> posts = List.generate(100, (i) {
      final randomUser = users[random.nextInt(users.length)];
      return Post(
        postId: 'post_$i',
        title: '오늘의 그림 일기 ${random.nextInt(1000)}',
        content: '일기를 써보겠습니다. 두근두근',
        imageUrl: 'https://picsum.photos/id/${random.nextInt(1000)}/200/',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        subject: 'Subject ${random.nextInt(100)}',
        weather: weatherOptions[random.nextInt(weatherOptions.length)],
        commentIds: [],
        user: randomUser,
        likes: random.nextInt(100),
      );
    });

    // 3) Comment 데이터 생성
    List<Comment> comments = List.generate(200, (i) {
      final randomPost = posts[random.nextInt(posts.length)];
      final randomUser = users[random.nextInt(users.length)];
      final commentId = 'comment_$i';

      randomPost.commentIds.add(commentId);

      return Comment(
        commentId: commentId,
        content: '그림이 멋지네요!',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        userId: randomUser.userId,
      );
    });

    // 4) Firestore에 업로드 (배치 쓰기)
    final batch = firestore.batch();

    // User 업로드
    for (final user in users) {
      final userRef = firestore.collection('users').doc(user.userId);
      batch.set(userRef, user.toFirestore());
    }

    // Post 업로드
    for (final post in posts) {
      final postRef = firestore.collection('posts').doc(post.postId);
      batch.set(postRef, post.toFirestore());
    }

    // Comment 업로드
    for (final comment in comments) {
      final commentRef =
          firestore.collection('comments').doc(comment.commentId);
      batch.set(commentRef, comment.toFirestore());
    }

    await batch.commit();
    print('Mock data uploaded.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              addMockData();
            },
            child: const Text("add data")),
      ),
    );
  }
}
