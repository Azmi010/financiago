import 'package:get/get.dart';

import '../controllers/challange_page_controller.dart';

class ChallangePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallangePageController>(
      () => ChallangePageController(),
    );
  }
}
