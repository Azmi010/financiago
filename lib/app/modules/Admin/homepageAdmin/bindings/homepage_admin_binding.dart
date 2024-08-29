import 'package:get/get.dart';

import '../controllers/homepage_admin_controller.dart';

class HomepageAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageAdminController>(
      () => HomepageAdminController(),
    );
  }
}
