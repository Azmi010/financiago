import 'package:get/get.dart';

import '../controllers/challenge_admin_controller.dart';

class ChallengeAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallengeAdminController>(
      () => ChallengeAdminController(),
    );
  }
}
