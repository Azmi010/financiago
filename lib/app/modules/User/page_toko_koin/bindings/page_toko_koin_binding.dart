import 'package:get/get.dart';

import '../controllers/page_toko_koin_controller.dart';

class PageTokoKoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageTokoKoinController>(
      () => PageTokoKoinController(),
    );
  }
}
