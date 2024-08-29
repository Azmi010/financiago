import 'package:get/get.dart';

import '../controllers/navigation_admin_controller.dart';

class NavigationAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationAdminController>(
      () => NavigationAdminController(),
    );
  }
}
