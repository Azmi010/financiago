import 'package:get/get.dart';

import '../controllers/quiz_admin_controller.dart';

class QuizAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizAdminController>(
      () => QuizAdminController(),
    );
  }
}
