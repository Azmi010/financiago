import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/homepage/views/list_category_by_day.dart';
import 'package:safeloan/app/modules/User/homepage/views/list_category_by_months.dart';
import 'package:safeloan/app/modules/User/homepage/views/list_category_by_weeks.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/views/page_toko_koin_view.dart';
import 'package:safeloan/app/modules/User/profile/controllers/profile_controller.dart';
import 'package:safeloan/app/modules/User/tab_quiz/views/leaderboard.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../controllers/homepage_controller.dart';
import 'package:badges/badges.dart' as badges;

class HomepageView extends GetView<HomepageController> {
  const HomepageView({super.key});

  Widget _notifBadge() {
  final HomepageController controller = Get.put(HomepageController());

  return Obx(() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 3, end: 7),
      badgeAnimation: const badges.BadgeAnimation.slide(),
      showBadge: controller.showCartBadge.value,
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.red,
        padding: EdgeInsets.all(5),
      ),
      badgeContent: Text(
        controller.notifBadgeAmount.value.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.grey[800],
            size: 25,
          ),
          onPressed: () {
            Get.toNamed('/notification');
            controller.markNotificationsAsRead(); 
          },
        ),
      ),
    );
  });
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
    var lebar = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ListTile(
                      title: const Text(
                        "Hai! Selamat Datang",
                        style: Utils.header,
                      ),
                      subtitle: Obx(
                        () => Text(
                            detailController.userData['fullName'] ?? "Anonim",
                            style: const TextStyle(color: Colors.black)),
                      ),
                      trailing: _notifBadge(),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: lebar * 0.05),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            poin("assets/images/poin.png",
                                '${detailController.userData['point'] ?? 0}',
                                onTap: () {
                              Get.to(LeaderBoard());
                            }),
                            poin("assets/images/koin.png",
                                '${detailController.userData['coin'] ?? 0}',
                                onTap: () {
                              Get.to(const PageTokoKoinView());
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
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
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMenuItem(
                              icon: Icons.school,
                              label: 'Edukasi',
                              onTap: () => Get.toNamed('/education')),
                          _buildMenuItem(
                              icon: Icons.chat,
                              label: 'Konseling',
                              onTap: () => Get.toNamed('/tab-counseling')),
                          _buildMenuItem(
                              icon: Icons.calculate,
                              label: 'Kalkulasi',
                              onTap: () => Get.toNamed('/calculator')),
                          _buildMenuItem(
                              icon: Icons.attach_money,
                              label: 'Pinjaman',
                              onTap: () => Get.toNamed('/loan')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                              child: GestureDetector(
                                onTap: () =>
                                    controller.navigateToDetailArticle(article),
                                child: Center(
                                  child: Image.network(
                                    article.image,
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                          child: Icon(Icons.error));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 15,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black38,
                                ),
                                child: Text(
                                  article.title.length > 20
                                      ? "Artikel : ${article.title.substring(0, 20)}..."
                                      : "Artikel : ${article.title}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 205,
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
                      margin: const EdgeInsets.only(right: 20, top: 10, left: 20),
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

  Widget _buildMenuItem(
      {required IconData icon,
      required String label,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Utils.biruDua),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Utils.biruDua),
          ),
        ],
      ),
    );
  }
}
