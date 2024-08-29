import 'package:get/get.dart';

import '../controllers/tab_quiz_controller.dart';

class TabQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabQuizController>(
      () => TabQuizController(),
    );
  }
}
