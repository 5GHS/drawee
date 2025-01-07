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

// Post Entity
class Post {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String subjectId;
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

    // 1) 서로 다른 닉네임 사용을 위해 userNames를 섞어둠
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

    // 2) Subject 주제 목록
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

    // 3) Subject 데이터를 미리 생성
    //    subjectMap: "topic" → Subject 객체
    //    subjectRefMap: "topic" → DocumentReference
    final subjectMap = <String, Subject>{};
    final subjectRefMap = <String, DocumentReference>{};

    for (final topic in topics) {
      final subjectRef = firestore.collection('subjects').doc();
      final subject = Subject(
        subjectId: subjectRef.id,
        topic: topic,
        postsIds: [],
      );
      // 여기서 "즉시" Firestore에 저장 가능하지만,
      // 이 예시는 일관성을 위해 batch에 넣을 예정

      subjectMap[topic] = subject;
      subjectRefMap[topic] = subjectRef;
    }

    // 4) User 데이터 생성 (20명)
    List<User> users = List.generate(20, (i) {
      final userId = firestore.collection('users').doc().id;
      return User(
        userId: userId,
        name: userNames[i], // 섞어놓은 닉네임
        imgUrl: 'https://picsum.photos/id/$i/200/',
      );
    });

    // 5) Post 데이터 생성 (100개)
    //    - Post를 Firestore에 저장할 때, 그 "문서 ID"를 subjectMap[topic].postsIds에 추가
    //    - Post 문서 ID를 알기 위해서는 doc()를 먼저 생성해야 함
    //    - 아래에서는 (postRef, post) 튜플을 담음
    final postTuples = List.generate(100, (index) {
      // Firestore 문서 ID 얻기
      final postRef = firestore.collection('posts').doc();

      // 랜덤 사용자
      final randomUser = users[random.nextInt(users.length)];
      // 랜덤 주제
      final randomTopic = topics[random.nextInt(topics.length)];

      // 댓글 생성
      final commentCount = 3 + random.nextInt(2); // 3 or 4
      List<Map<String, dynamic>> comments = List.generate(commentCount, (_) {
        final commentWriter = users[random.nextInt(users.length)];
        return Comment(
          content: '행복하세요 ^^',
          createdAt: DateTime.now().subtract(Duration(days: random.nextInt(3))),
          userId: commentWriter.userId,
        ).toFirestore();
      });

      // Post 객체
      final post = Post(
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

      // ★ subjectMap에서 randomTopic에 해당하는 subject의 postsIds에
      //   지금 만들 postRef.id를 추가
      subjectMap[randomTopic]!.postsIds.add(postRef.id);

      // postRef와 post 객체를 튜플로 반환
      return (postRef: postRef, post: post);
    });

    // 6) 이제 Batch로 일괄 업로드
    final batch = firestore.batch();

    // 6-1) Subject 업로드
    //     이미 subjectMap과 subjectRefMap이 있으니, set()으로 저장
    for (final topic in topics) {
      final subjectRef = subjectRefMap[topic]!;
      final subjectData = subjectMap[topic]!.toFirestore();
      batch.set(subjectRef, subjectData);
    }

    // 6-2) User 업로드
    for (final user in users) {
      final userRef = firestore.collection('users').doc(user.userId);
      batch.set(userRef, user.toFirestore());
    }

    // 6-3) Post 업로드
    for (final tuple in postTuples) {
      final postRef = tuple.postRef;
      final post = tuple.post;
      batch.set(postRef, post.toFirestore());
    }

    await batch.commit();
    print('Mock data uploaded (including postsIds in subject).');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: addMockData,
          child: const Text("add data"),
        ),
      ),
    );
  }
}
