import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Weather Enum
enum Weather { sunny, rainy, cloudy, windy, snowy }

// -----------------------
// 1) User Entity
// -----------------------
class User {
  final String userId;
  final String name;
  final String imgUrl;

  // 추가 필드
  final List<String> likedPostsIds;
  final List<String> writtenPostsIds;

  User({
    required this.userId,
    required this.name,
    required this.imgUrl,
    required this.likedPostsIds,
    required this.writtenPostsIds,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imgUrl': imgUrl,
      'likedPostsIds': likedPostsIds,
      'writtenPostsIds': writtenPostsIds,
    };
  }
}

// -----------------------
// 2) Subject
// -----------------------
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

// -----------------------
// 3) Post Entity
// -----------------------
class Post {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String subjectId;
  final Weather weather;
  final List<Map<String, dynamic>> comments;
  final String userId;
  int likes;

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

// -----------------------
// 4) Comment Entity
// -----------------------
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

// -----------------------
// 5) Mock Data Upload
// -----------------------
class AddMockData extends StatelessWidget {
  const AddMockData({Key? key}) : super(key: key);

  Future<void> addMockData() async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    final random = Random();
    const weatherOptions = Weather.values;

    // 1) 유저 이름 리스트(섞음)
    final userNames = [
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
    ]..shuffle(random);

    // 2) Subject 목록
    final topics = [
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

    // Subject 데이터 준비
    final subjectMap = <String, Subject>{};
    final subjectRefMap = <String, DocumentReference>{};

    for (final topic in topics) {
      final subjectRef = firestore.collection('subjects').doc();
      final subject = Subject(
        subjectId: subjectRef.id,
        topic: topic,
        postsIds: [],
      );
      subjectMap[topic] = subject;
      subjectRefMap[topic] = subjectRef;
    }

    // --------------------------
    // 3) User 생성 (liked/writtenPostsIds 초기화)
    // --------------------------
    final users = List.generate(20, (i) {
      final userId = firestore.collection('users').doc().id;
      return User(
        userId: userId,
        name: userNames[i],
        imgUrl: 'https://picsum.photos/id/$i/200/',
        likedPostsIds: [],
        writtenPostsIds: [],
      );
    });

    // userId -> User 객체 매핑 (나중에 업데이트 편하게)
    final userMap = {
      for (var u in users) u.userId: u,
    };

    // --------------------------
    // 4) Post 생성
    // --------------------------
    // Post를 만들 때, 작성자의 writtenPostsIds에 postId 추가
    // 그리고 랜덤으로 "좋아요" 누른 유저도 골라, likedPostsIds에 추가 (옵션)
    final postTuples = List.generate(100, (i) {
      final postRef = firestore.collection('posts').doc();

      // 랜덤 작성자
      final writer = users[random.nextInt(users.length)];

      // 랜덤 topic
      final randomTopic = topics[random.nextInt(topics.length)];

      // 댓글 생성
      final commentCount = 3 + random.nextInt(2);
      final comments = List.generate(commentCount, (_) {
        final commenter = users[random.nextInt(users.length)];
        return Comment(
          content: '행복하세요 ^^',
          createdAt: DateTime.now().subtract(Duration(days: random.nextInt(3))),
          userId: commenter.userId,
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
        userId: writer.userId, // 작성자
        likes: 0, // 우선 0으로 시작
      );

      // 4-1) 작성자(writer)의 writtenPostsIds에 postRef.id 추가
      userMap[writer.userId]!.writtenPostsIds.add(postRef.id);

      // 4-2) Subject의 postsIds에도 추가
      subjectMap[randomTopic]!.postsIds.add(postRef.id);

      // 4-3) (옵션) 좋아요 누른 유저를 랜덤 선택
      //     - ex) 0~5명 사이의 유저가 좋아요를 누른다고 가정
      final likeCount = random.nextInt(6); // 0..5
      for (int j = 0; j < likeCount; j++) {
        final liker = users[random.nextInt(users.length)];
        // liker가 작성자와 같을 수도 있음(자기 글 좋아요)
        userMap[liker.userId]!.likedPostsIds.add(postRef.id);

        // Post.likes 증가
        post.likes++;
      }

      return (postRef: postRef, post: post);
    });

    // --------------------------
    // 5) Batch 업로드
    // --------------------------
    final batch = firestore.batch();

    // (A) Subject 업로드
    for (final topic in topics) {
      final subjectRef = subjectRefMap[topic]!;
      final subjectData = subjectMap[topic]!.toFirestore();
      batch.set(subjectRef, subjectData);
    }

    // (B) User 업로드 (likedPostsIds, writtenPostsIds 반영됨)
    for (final user in userMap.values) {
      final userRef = firestore.collection('users').doc(user.userId);
      batch.set(userRef, user.toFirestore());
    }

    // (C) Post 업로드
    for (final tuple in postTuples) {
      final postRef = tuple.postRef;
      final post = tuple.post;
      batch.set(postRef, post.toFirestore());
    }

    await batch.commit();
    print('Mock data uploaded with liked/writtenPostsIds in users!');
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
