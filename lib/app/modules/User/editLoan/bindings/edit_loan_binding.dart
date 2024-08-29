import 'package:get/get.dart';

import '../controllers/edit_loan_controller.dart';

class EditLoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditLoanController>(
      () => EditLoanController(),
    );
  }
}
