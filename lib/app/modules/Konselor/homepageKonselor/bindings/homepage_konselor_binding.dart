import 'package:get/get.dart';

import '../controllers/homepage_konselor_controller.dart';

class HomepageKonselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageKonselorController>(
      () => HomepageKonselorController(),
    );
  }
}
