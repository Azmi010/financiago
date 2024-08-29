import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String content;
  final String source;
  final String image; // Tambahkan atribut untuk gambar
  final DateTime postAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.source,
    required this.image, // Tambahkan parameter pada konstruktor
    required this.postAt,
  });

  factory Article.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      source: data['source'] ?? '',
      image: data['image'] ?? '', // Ambil URL gambar dari dokumen
      postAt: (data['postAt'] as Timestamp).toDate(),
    );
  }
}
