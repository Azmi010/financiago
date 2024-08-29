import 'package:cloud_firestore/cloud_firestore.dart';

class CounselingSession{
  final String id;
  final DateTime jadwal;
  final int durasi;
  final String tautanGmeet;
  final String konselorId;
  final String userId;

  CounselingSession({
    required this.id,
    required this.jadwal,
    required this.durasi,
    required this.tautanGmeet,
    required this.konselorId,
    required this.userId
  });

  factory CounselingSession.fromDocument(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CounselingSession(
      id: doc.id,
      jadwal: (data['jadwal'] as Timestamp).toDate(),
      durasi: data['durasi'] ?? 0,
      tautanGmeet: data['tautanGmeet'] ?? '',
      konselorId: data['konselorId'] ?? '',
      userId: data['userId'] ?? ''
    );
  }
}

class CounselingSessionWithUserData {
  final CounselingSession counseling;
  final Map<String, dynamic> userData;

  CounselingSessionWithUserData({required this.counseling, required this.userData});
}