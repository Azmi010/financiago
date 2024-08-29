import 'package:get/get.dart';

import '../controllers/edit_video_admin_controller.dart';

class EditVideoAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditVideoAdminController>(
      () => EditVideoAdminController(),
    );
  }
}
