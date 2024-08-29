import 'package:get/get.dart';

import '../controllers/profile_konselor_controller.dart';

class ProfileKonselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileKonselorController>(
      () => ProfileKonselorController(),
    );
  }
}
