import 'package:get/get.dart';

import '../controllers/detail_loan_controller.dart';

class DetailLoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailLoanController>(
      () => DetailLoanController(),
    );
  }
}
