import 'package:get/get.dart';

import '../controllers/add_loan_controller.dart';

class AddLoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLoanController>(
      () => AddLoanController(),
    );
  }
}
