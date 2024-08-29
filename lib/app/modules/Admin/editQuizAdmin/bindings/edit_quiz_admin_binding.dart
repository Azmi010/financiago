import 'package:get/get.dart';

import '../controllers/edit_quiz_admin_controller.dart';

class EditQuizAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditQuizAdminController>(
      () => EditQuizAdminController(),
    );
  }
}
