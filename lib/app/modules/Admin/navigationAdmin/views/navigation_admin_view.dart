import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Admin/educationAdmin/views/education_admin_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../../homepageAdmin/views/homepage_admin_view.dart';
import '../../quizAdmin/views/quiz_admin_view.dart';
import '../controllers/navigation_admin_controller.dart';

class NavigationAdminView extends GetView<NavigationAdminController> {
  const NavigationAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationAdminController controller =
        Get.put(NavigationAdminController());

    final int initialIndex = Get.arguments?['initialIndex'] ?? 0;
    controller.selectedIndex.value = initialIndex;

    final List<Widget> pages = [
      const HomepageAdminView(),
      const QuizAdminView(),
      const EducationAdminView(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Utils.backgroundCard,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.changePage(index);
          },
          selectedItemColor: Utils.biruTiga,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.selectedIndex.value == 0
                    ? const Icon(
                        Icons.home,
                      )
                    : const Icon(
                        Icons.home_outlined,
                      ),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.selectedIndex.value == 1
                    ? const Icon(
                        Icons.quiz,
                      )
                    : const Icon(
                        Icons.quiz_outlined,
                      ),
              ),
              label: 'Kuis',
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.selectedIndex.value == 2
                    ? const Icon(
                        Icons.cast_for_education,
                      )
                    : const Icon(
                        Icons.cast_for_education_outlined,
                      ),
              ),
              label: 'Edukasi',
            ),
          ],
        ),
      ),
    );
  }
}
