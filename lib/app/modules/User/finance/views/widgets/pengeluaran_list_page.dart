import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/modules/User/finance/views/widgets/expense_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../../../detailFinance/views/detail_finance_view.dart';
import '../../controllers/pengeluaran_controller.dart';

class PengeluaranListPage extends GetView<PengeluaranController> {
  const PengeluaranListPage({super.key});

  Widget cardItem(String title, double nominal, String kategori,
      Color colorCategory, DateTime tanggal, String docId) {
    final NumberFormat numberFormat = NumberFormat('#,##0', 'id_ID');
    String formattedNominal = numberFormat.format(nominal);
    String formattedDate = DateFormat('dd/MM/yyyy').format(tanggal);

    return GestureDetector(
      onTap: () {
        Get.to(
          () => const DetailFinanceView(),
          arguments: {
            'docId': docId,
            'type': 'expense',
          },
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(12),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Utils.titleStyle),
                      const SizedBox(height: 8),
                      Text('Rp $formattedNominal', style: Utils.subtitle),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorCategory,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      kategori,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PengeluaranController controller = Get.put(PengeluaranController());
    final NumberFormat numberFormat = NumberFormat('#,##0', 'id_ID');

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Pengeluaran',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Rp ${numberFormat.format(controller.totalExpenses.value)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 0,
                            blurRadius: 30,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Obx(() => DropdownButton<String>(
                            value: controller.selectedFilter.value,
                            items: <String>[
                              'Harian',
                              'Mingguan',
                              'Bulanan',
                              'Tahunan',
                              'Semua Data'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedFilter.value = newValue;
                                controller.listenToExpenseData();
                              }
                            },
                            elevation: 1,
                            underline: const SizedBox(),
                            isExpanded: false,
                            icon: const Icon(Icons.filter_list,
                                color: Colors.black54),
                            style: const TextStyle(color: Colors.black87),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    if (controller.expenseList.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada data pengeluaran',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: controller.expenseList.length,
                        itemBuilder: (context, index) {
                          var expense = controller.expenseList[index];
                          return cardItem(
                            expense['title'] ?? 'Unknown',
                            (expense['nominal'] as num).toDouble(),
                            expense['category'] ?? 'Unknown',
                            Utils.biruDua,
                            expense['date'] is DateTime
                                ? expense['date'] as DateTime
                                : DateTime.parse(expense['date'].toString()),
                            expense['docId'] ?? '',
                          );
                        },
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.pickImage();
                            },
                            child: const Text("Upload Gambar"),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.takeImage();
                            },
                            child: const Text("Foto Gambar"),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(ExpenseView());
                            },
                            child: const Text("Isi Sendiri"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              backgroundColor: Utils.biruDua,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
