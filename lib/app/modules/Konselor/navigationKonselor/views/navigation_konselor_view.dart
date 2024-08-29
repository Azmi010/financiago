import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Konselor/edit_jadwal/views/edit_jadwal_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../../homepageKonselor/views/homepage_konselor_view.dart';
import '../../profileKonselor/views/profile_konselor_view.dart';
import '../controllers/navigation_konselor_controller.dart';

class NavigationKonselorView extends GetView<NavigationKonselorController> {
  const NavigationKonselorView({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigationKonselorController controller = Get.put(NavigationKonselorController());
    final int initialIndex = Get.arguments?['initialIndex'] ?? 0;
    controller.selectedIndex.value = initialIndex;
    
    final List<Widget> pages = [
      const HomepageKonselorView(),
      const EditJadwalView(),
      const ProfileKonselorView(),
    ];

    return Obx(() => Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changePage,
            selectedItemColor: Utils.biruTiga,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Jadwal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ));
  }
}
