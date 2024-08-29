import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final String subTitle;
  final String description;
  final int point;
  final int coin;
  final int requiredCount;
  final String category;
  final DateTime createdAt;
  final String imageChallenge;

  Challenge({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.point,
    required this.coin,
    required this.requiredCount,
    required this.category,
    required this.createdAt,
    required this.imageChallenge,
  });

  factory Challenge.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Challenge(
      id: doc.id,
      title: data['title'] ?? '',
      subTitle: data['subTitle'] ?? '',
      description: data['description'] ?? '',
      point: data['point'],
      coin: data['coin'],
      requiredCount: data['requiredCount'],
      category: data['category'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageChallenge: data['imageChallenge'] ?? '',
    );
  }
}

class CompletedBy {
  final String userId;
  final DateTime completedAt;

  CompletedBy({
    required this.userId,
    required this.completedAt,
  });

  factory CompletedBy.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CompletedBy(
      userId: doc.id,
      completedAt: (data['completedAt'] as Timestamp).toDate(),
    );
  }
}