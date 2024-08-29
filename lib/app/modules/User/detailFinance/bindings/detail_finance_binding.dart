import 'package:get/get.dart';
import '../controllers/detail_finance_controller.dart';

class DetailFinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailFinanceController>(
      () => DetailFinanceController(),
    );
  }
}
