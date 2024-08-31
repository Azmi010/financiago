import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/confirm_show_dialog_widget.dart';
import '../controllers/loan_controller.dart';

class LoanView extends GetView<LoanController> {
  const LoanView({super.key});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'id_ID');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pinjaman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp ${numberFormat.format(controller.totalLoan.value)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.listLoans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Tidak Ada Pinjaman'));
                  }

                  var loanDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: loanDocs.length,
                    itemBuilder: (context, index) {
                      var loanData = loanDocs[index].data();
                      var loanId = loanDocs[index].id;

                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Utils.backgroundCard,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                spreadRadius: 0,
                                blurRadius: 30,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      loanData['namaPinjaman'] ?? 'Pinjaman',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              FontAwesomeIcons.penToSquare,
                                              color: Colors.blue),
                                          onPressed: () => Get.toNamed(
                                              '/edit-loan',
                                              arguments: loanId),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: Colors.red),
                                          onPressed: () => confirmShowDialog(
                                            judul:
                                                "Apakah anda yakin ingin menghapus pinjaman ini?",
                                            onPressed: () =>
                                                controller.deleteLoan(loanId),
                                            context: context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.moneyBillWave,
                                        color: Colors.green),
                                    const SizedBox(width: 10),
                                    Text(
                                        'Rp. ${numberFormat.format(loanData['jumlahPinjaman'])}'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.percent,
                                        color: Colors.orange),
                                    const SizedBox(width: 10),
                                    Text('Bunga ${loanData['bunga'] ?? 0}%'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.calendarDays,
                                        color: Colors.purple),
                                    const SizedBox(width: 10),
                                    Text(
                                        'Total Angsuran: ${loanData['angsuran'] ?? 0} bulan'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-loan'),
        backgroundColor: Utils.biruDua,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
