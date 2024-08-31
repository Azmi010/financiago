import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/homepage/views/artikel_top_bar.dart';
import 'package:safeloan/app/modules/User/homepage/views/list_category_by_day.dart';
import 'package:safeloan/app/modules/User/homepage/views/list_category_by_months.dart';
import 'package:safeloan/app/modules/User/homepage/views/list_category_by_weeks.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/views/page_toko_koin_view.dart';
import 'package:safeloan/app/modules/User/profile/controllers/profile_controller.dart';
import 'package:safeloan/app/modules/User/tab_counseling/views/tab_counseling_view.dart';
import 'package:safeloan/app/modules/User/tab_quiz/views/leaderboard.dart';
import 'package:safeloan/app/modules/User/tab_quiz/views/tab_quiz_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../controllers/homepage_controller.dart';

class HomepageView extends GetView<HomepageController> {
  const HomepageView({super.key});

  Widget menuHomepage(BuildContext context, String label, String icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(width: 5, color: Colors.white)),
                child: Image.asset(
                  icon,
                  scale: 5,
                )),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget poin(String icon, String poin, {VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Utils.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const []),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(icon),
            const SizedBox(
              width: 5,
            ),
            Text(
              poin,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomepageController controller = Get.put(HomepageController());
    final ProfileController detailController = Get.put(ProfileController());
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hai! ${detailController.userData['fullName']}",
                  style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              Obx(
                () => Row(
                  children: [
                    poin("assets/images/poin.png",
                        '${detailController.userData['point'] ?? 0}',
                        onTap: () => Get.to(LeaderBoard())),
                    const SizedBox(width: 5),
                    poin("assets/images/koin.png",
                        '${detailController.userData['coin'] ?? 0}',
                        onTap: () => Get.to(const PageTokoKoinView())),
                    const SizedBox(width: 10),
                    
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    menuHomepage(
                      context,
                      'Gamifikasi',
                      'assets/images/icon_game.png',
                      Utils.biruTiga,
                      () {
                        Get.to(() => const TabQuizView());
                      },
                    ),
                    menuHomepage(
                      context,
                      'Konseling',
                      'assets/images/icon_konseling.png',
                      Utils.biruSatu,
                      () {
                        Get.to(() => const TabCounselingView());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Artikel Terbaru",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const ArtikelTopBar());
                        },
                        child: const Row(
                          children: [
                            Text(
                              "lihat selengkapnya",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () {
                    if (controller.articleImages.isEmpty) {
                      return const Center(
                          child: Text('Tidak ada artikel untuk ditampilkan'));
                    }
                    return CarouselSlider.builder(
                      itemCount: controller.articleImages.length,
                      itemBuilder: (context, index, realIndex) {
                        var article = controller.articleImages[index];
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 200,
                              decoration: BoxDecoration(
                                color: Utils.backgroundCard,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  article.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Icon(Icons.error));
                                  },
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title.length > 40
                                                ? "${article.title.substring(0, 40)}..."
                                                : article.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.white70,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "3 menit",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          onPressed: () => controller
                                              .navigateToDetailArticle(article),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("Baca"),
                                              const SizedBox(width: 5),
                                              Image.asset(
                                                'assets/images/read.png',
                                                height: 20,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () =>
                                    controller.navigateToDetailArticle(article),
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.only(bottom: 50),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(right: 20, top: 10, left: 20),
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
                            borderRadius: BorderRadius.circular(25),
                            color: Utils.biruTiga,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Utils.biruTiga,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: 'Harian'),
                            Tab(text: 'Mingguan'),
                            Tab(text: 'Bulanan'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      height: 400,
                      child: TabBarView(
                        children: [
                          ListCategoryByDays(),
                          ListCategoryByWeeks(),
                          ListCategoryByMonths(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
