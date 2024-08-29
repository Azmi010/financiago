import 'package:get/get.dart';

import '../controllers/navigation_konselor_controller.dart';

class NavigationKonselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationKonselorController>(
      () => NavigationKonselorController(),
    );
  }
}
