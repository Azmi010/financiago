import 'package:get/get.dart';

import '../controllers/pinjol_list_controller.dart';

class PinjolListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinjolListController>(
      () => PinjolListController(),
    );
  }
}
