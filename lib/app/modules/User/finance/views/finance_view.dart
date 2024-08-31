import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/finance/views/widgets/pemasukan_list_page.dart';
import 'package:safeloan/app/modules/User/finance/views/widgets/pengeluaran_list_page.dart';
import 'package:safeloan/app/modules/User/loan/controllers/loan_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/tab_bar_widget.dart';
import '../../loan/views/loan_view.dart';
import '../controllers/finance_controller.dart';

class FinanceView extends GetView<FinanceController> {
  const FinanceView({super.key});

  Widget tabBar() {
    return const TabBarWidget(views: [
      PemasukanListPage(),
      PengeluaranListPage(),
      LoanView()
    ], tabLabels: [
      'Pemasukan',
      'Pengeluaran',
      'Pinjaman'
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LoanController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Keuangan", style: Utils.header,),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: tabBar(),
    );
  }
}
