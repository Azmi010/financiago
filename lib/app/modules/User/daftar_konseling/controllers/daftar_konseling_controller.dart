import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DaftarKonselingController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  Future<bool> bookSchedule(String counselingId) async {
  try {
    final userId = firebaseAuth.currentUser?.uid;
    if (userId == null) {
      print('User not authenticated.');
      return false;
    }

    // Cek apakah pengguna sudah memiliki jadwal lain
    final existingSchedules = await firestore
        .collection('counselings')
        .where('userId', isEqualTo: userId)
        .get();

    if (existingSchedules.docs.isNotEmpty) {
      print('User already has a schedule.');
      return false;
    }

    // Ambil data counseling
    final counselingDoc = await firestore.collection('counselings').doc(counselingId).get();
    final counselingData = counselingDoc.data();

    if (counselingData == null) {
      print('Counseling data not found.');
      return false;
    }

    // Ambil data pengguna
    final userDoc = await firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();

    if (userData == null) {
      print('User data not found.');
      return false;
    }

    final userCoin = userData['coin'] ?? 0;
    if (userCoin < 50) {
      print('Insufficient coins.');
      return false;
    }

    // Update counseling document with user ID
    await firestore.collection('counselings').doc(counselingId).update({'userId': userId});

    // Kurangi coin dari saldo pengguna
    await firestore.collection('users').doc(userId).update({'coin': userCoin - 50});

    print('Schedule booked successfully.');
    return true;
  } catch (e) {
    print('Error booking schedule: $e');
    return false;
  }
}

}
