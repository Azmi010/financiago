import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/counseling/views/counseling_view.dart';
import 'package:safeloan/app/modules/User/daftar_konseling/views/daftar_konseling_view.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/views/page_toko_koin_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';

import '../controllers/tab_counseling_controller.dart';

class TabCounselingView extends GetView<TabCounselingController> {
  const TabCounselingView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Konseling Keuangan', style: Utils.header),
            centerTitle: true,
            leading: const ButtonBackLeading(),
            actions: [Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () => Get.to(const PageTokoKoinView()),
                child: Image.asset("assets/images/toko.png", scale: 3,)))],),
            
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Utils.backgroundCard,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: const Text(
                          'Ayo konsultasikan kondisi finansial-mu dengan konselor keuangan yang tersedia agar terhindar dari lilitan pinjaman online!',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/konseling.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(2),
              height: 50,
              decoration: BoxDecoration(
                color: Utils.backgroundCard,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Utils.biruTiga,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Jadwalku"),
                    Tab(text: "Daftar Konseling"),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  CounselingView(),
                  DaftarKonselingView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
