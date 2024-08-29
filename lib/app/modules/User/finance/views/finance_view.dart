import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/finance/views/widgets/pemasukan_list_page.dart';
import 'package:safeloan/app/modules/User/finance/views/widgets/pengeluaran_list_page.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/tab_bar_widget.dart';
import '../controllers/finance_controller.dart';

class FinanceView extends GetView<FinanceController> {
  const FinanceView({super.key});

  Widget tabBar() {
    return const TabBarWidget(views: [
      PemasukanListPage(),
      PengeluaranListPage(),
    ], tabLabels: [
      'Pemasukan',
      'Pengeluaran'
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
