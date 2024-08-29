import 'package:cloud_firestore/cloud_firestore.dart';

class Video{
  final String id;
  final String title;
  final String link;
  final String description;
  final DateTime postAt;

  Video({
    required this.id,
    required this.title,
    required this.link,
    required this.description,
    required this.postAt,
  });

  factory Video.fromDocument(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Video(
      id: doc.id,
      title: data['title'] ?? '',
      link: data['link'] ?? '',
      description: data['description'] ?? '',
      postAt: (data['postAt'] as Timestamp).toDate(),
    );
  }


}