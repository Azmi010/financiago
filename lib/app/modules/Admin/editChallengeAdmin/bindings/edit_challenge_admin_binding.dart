import 'package:get/get.dart';

import '../controllers/edit_challenge_admin_controller.dart';

class EditChallengeAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditChallengeAdminController>(
      () => EditChallengeAdminController(),
    );
  }
}
