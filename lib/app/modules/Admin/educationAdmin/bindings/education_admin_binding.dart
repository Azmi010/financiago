import 'package:get/get.dart';

import '../controllers/education_admin_controller.dart';

class EducationAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EducationAdminController>(
      () => EducationAdminController(),
    );
  }
}
