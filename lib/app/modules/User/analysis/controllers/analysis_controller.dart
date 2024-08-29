import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeloan/app/services/analysis_service.dart';

class AnalysisController extends GetxController {
  final offset = 0.0.obs;
  final AnalysisService _analysisService = Get.put(AnalysisService());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    animateRobot();
  }

  void animateRobot() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      offset.value = 10.0;
      await Future.delayed(const Duration(milliseconds: 500));
      offset.value = 0.0;
      return true;
    });
  }

  Future<Map<String, dynamic>> createAnalisis() async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;

      // Ambil data pendapatan dari subcollection income
      final incomeSnapshot = await _firestore
          .collection('finances')
          .doc(userId)
          .collection('income')
          .get();

      // Ambil data pengeluaran dari subcollection expanse
      final expenseSnapshot = await _firestore
          .collection('finances')
          .doc(userId)
          .collection('expense')
          .get();

      // Hitung total pendapatan
      double totalPendapatan = incomeSnapshot.docs
          .map((doc) => doc.data()['nominal'] as double)
          .fold(0, (sum, nominal) => sum + nominal);

      // Hitung total pengeluaran dan pengeluaran per kategori
      double totalPengeluaran = 0;
      double pengeluaranDarurat = 0;
      double pengeluaranHiburan = 0;
      double pengeluaranPendidikan = 0;

      for (var doc in expenseSnapshot.docs) {
        double nominal = doc.data()['nominal'] as double;
        String category = doc.data()['category'] as String;

        totalPengeluaran += nominal;

        switch (category) {
          case 'Darurat':
            pengeluaranDarurat += nominal;
            break;
          case 'Hiburan':
            pengeluaranHiburan += nominal;
            break;
          case 'Pendidikan':
            pengeluaranPendidikan += nominal;
            break;
        }
      }

      // Ambil data user
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final userData = userSnapshot.data() as Map<String, dynamic>;

      // Ambil data hutang jika ada
      double totalHutang = 0;
      if (await userSnapshot.reference
          .collection('loans')
          .get()
          .then((value) => value.docs.isNotEmpty)) {
        final loansSnapshot =
            await userSnapshot.reference.collection('loans').get();
        totalHutang = loansSnapshot.docs
            .map((doc) => doc.data()['jumlahPinjaman'] as double)
            .fold(0, (sum, amount) => sum + amount);
      }

      // Hitung rasio-rasio
      double rasioTabungan =
          (totalPendapatan - totalPengeluaran) / totalPendapatan;
      double rasioDarurat = pengeluaranDarurat / totalPendapatan;
      double rasioHiburan = pengeluaranHiburan / totalPendapatan;
      double rasioPendidikan = pengeluaranPendidikan / totalPendapatan;
      String profesi = userData['profession'];
      // Siapkan data untuk dikirim ke API
      Map<String, dynamic> apiData = {
        'pendapatan': totalPendapatan,
        'pengeluaran': totalPengeluaran,
        'rasio_tabungan': rasioTabungan,
        'rasio_darurat': rasioDarurat,
        'rasio_liburan': rasioHiburan,
        'rasio_pendidikan': rasioPendidikan,
        'usia': userData['age'] ?? 0,
        'profesi': profesi.toLowerCase() ?? '',
        'total_hutang': totalHutang,
      };

      // Kirim data ke API dan dapatkan hasilnya
      final result = await _analysisService.getAnalysis(apiData);
      print(result);
      return result;
    } catch (e) {
      print('Error in createAnalisis: $e');
      rethrow;
    }
  }
}
