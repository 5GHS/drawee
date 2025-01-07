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
  final String imgUrl;

  User({
    required this.userId,
    required this.name,
    required this.imgUrl,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imgUrl': imgUrl,
    };
  }
}

// Subject
class Subject {
  final String subjectId;
  final String topic;
  final List<String> postsIds;

  Subject({
    required this.subjectId,
    required this.topic,
    required this.postsIds,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'topic': topic,
      'postsIds': postsIds,
    };
  }
}

// Post Entity (User 객체를 직접 보관)
class Post {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String subjectId; // subject 문서 id
  final Weather weather;
  final List<Map<String, dynamic>> comments;
  final String userId;
  final int likes;

  Post({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.subjectId,
    required this.weather,
    required this.comments,
    required this.userId,
    required this.likes,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'subjectId': subjectId,
      'weather': weather.name,
      'comments': comments,
      'userId': userId,
      'likes': likes,
    };
  }
}

// Comment Entity
class Comment {
  final String content;
  final DateTime createdAt;
  final String userId;

  Comment({
    required this.content,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toFirestore() {
    return {
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
    userNames.shuffle(random);

    List<String> topics = [
      '겨울 도시',
      '쓸쓸함',
      '식사 시간',
      '체력 단련',
      '인내',
      '선물',
      '바람',
      '이름',
      '얼굴',
      '시골쥐와 서울쥐',
      '콩쥐팥쥐',
      '얼음 땡',
      '숨바꼭질',
      '도시남녀',
      '풍수지리',
      '축구',
      '야구',
      '시합',
      '경쟁',
      '새로운 기술',
    ];

    // Subject 데이터
    Map<String, Subject> subjectMap = {};
    for (final topic in topics) {
      final subjectRef = firestore.collection('subjects').doc();
      final subject =
          Subject(subjectId: subjectRef.id, topic: topic, postsIds: []);
      await subjectRef.set(subject.toFirestore());
      subjectMap[topic] = subject;
    }

    // 1) User 데이터 생성
    List<User> users = List.generate(20, (i) {
      final userId = firestore.collection('users').doc().id;
      return User(
        userId: userId,
        name: userNames[i],
        imgUrl: 'https://picsum.photos/id/$i/200/',
      );
    });

    // subject 데이터 생성

    // 2) Post 데이터 생성
    List<Post> posts = List.generate(100, (i) {
      final randomUser = users[random.nextInt(users.length)];
      final randomTopic = topics[random.nextInt(topics.length)];
      List<Map<String, dynamic>> comments =
          List.generate(3 + random.nextInt(2), (j) {
        final commentWriter = users[random.nextInt(users.length)];
        return Comment(
                content: '행복하세요 ^^',
                createdAt:
                    DateTime.now().subtract(Duration(days: random.nextInt(3))),
                userId: commentWriter.userId)
            .toFirestore();
      });
      return Post(
        title: '오늘의 그림 일기 ${random.nextInt(1000)}',
        content: '일기를 써보겠습니다. 두근두근',
        imageUrl: 'https://picsum.photos/id/${random.nextInt(1000)}/200/',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        subjectId: subjectMap[randomTopic]!.subjectId,
        weather: weatherOptions[random.nextInt(weatherOptions.length)],
        comments: comments,
        userId: randomUser.userId,
        likes: random.nextInt(100),
      );
    });

    // 4) Firestore에 업로드 (배치 쓰기)
    final batch = firestore.batch();

    // User 업로드
    for (final user in users) {
      final userRef = firestore.collection('users').doc();
      batch.set(userRef, user.toFirestore());
    }

    // Post 업로드
    for (final post in posts) {
      final postRef = firestore.collection('posts').doc();
      batch.set(postRef, post.toFirestore());
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
