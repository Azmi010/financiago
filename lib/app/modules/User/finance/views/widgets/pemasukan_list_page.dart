import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../../../detailFinance/views/detail_finance_view.dart';
import '../../controllers/pemasukan_controller.dart';
import 'income_view.dart';

class PemasukanListPage extends GetView<PemasukanController> {
  const PemasukanListPage({super.key});

  Widget cardItem(Map<String, dynamic> income, String docId, String type) {
    final NumberFormat numberFormat = NumberFormat('#,##0', 'id_ID'); 
    String formattedNominal = numberFormat.format(income['nominal']);
    String formattedDate = DateFormat('dd/MM/yyyy').format(income['date']);

    return GestureDetector(
      onTap: () {
        Get.to(() => const DetailFinanceView(), arguments: {'docId': docId, 'type': type,},);
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
                      Text(income['title'] ?? 'Unknown', style: Utils.titleStyle),
                      const SizedBox(height: 8),
                      Text('Rp $formattedNominal', style: Utils.subtitle),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_upward_outlined,
                    color: Colors.green,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Utils.biruDua,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      income['category'] ?? 'Unknown',
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
    final PemasukanController controller = Get.put(PemasukanController());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
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
                                'Total Pemasukan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Rp ${NumberFormat('#,##0', 'id_ID').format(controller.totalIncome.value)}',
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                        items: <String>['Harian', 'Mingguan', 'Bulanan', 'Tahunan', 'Semua Data']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.selectedFilter.value = newValue;
                            controller.listenToIncomeData();
                          }
                        },
                        elevation: 1,
                        underline: const SizedBox(),
                        isExpanded: false,
                        icon: const Icon(Icons.filter_list, color: Colors.black54),
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
                    if (controller.incomeList.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada data pemasukan',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: controller.incomeList.length,
                        itemBuilder: (context, index) {
                          var income = controller.incomeList[index];
                          String docId = controller.incomeList[index]['docId'] ?? '';
                          String type = 'income'; 
                          return cardItem(income, docId, type);
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
                Get.to(IncomeView());
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
