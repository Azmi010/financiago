import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/detail_loan_controller.dart';

class DetailLoanView extends GetView<DetailLoanController> {
  const DetailLoanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pinjaman'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          final loanData = controller.loanData;

          if (loanData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                _buildDetailCard(
                  title: 'Nama Pinjaman',
                  icon: FontAwesomeIcons.fileLines,
                  content: loanData['namaPinjaman'] ?? 'N/A',
                ),
                _buildDetailCard(
                  title: 'Jumlah Pinjaman',
                  icon: FontAwesomeIcons.moneyBillWave,
                  content: 'Rp ${loanData['jumlahPinjaman'] ?? 0}',
                ),
                _buildDetailCard(
                  title: 'Jumlah Angsuran',
                  icon: FontAwesomeIcons.calendarCheck,
                  content: '${loanData['angsuran'] ?? 0} bulan',
                ),
                _buildDetailCard(
                  title: 'Bunga',
                  icon: FontAwesomeIcons.percent,
                  content: '${loanData['bunga'] ?? 0}%',
                ),
                _buildDetailCard(
                  title: 'Tanggal Peminjaman',
                  icon: FontAwesomeIcons.calendarDays,
                  content: loanData['tanggalPinjaman'] ?? 'N/A',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}
