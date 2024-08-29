import 'package:get/get.dart';

import '../controllers/counseling_controller.dart';

class CounselingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounselingController>(
      () => CounselingController(),
    );
  }
}
