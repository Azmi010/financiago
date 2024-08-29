import 'package:get/get.dart';

import '../controllers/tab_counseling_controller.dart';

class TabCounselingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabCounselingController>(
      () => TabCounselingController(),
    );
  }
}
