import 'package:get/get.dart';

import '../controllers/daftar_konseling_controller.dart';

class DaftarKonselingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarKonselingController>(
      () => DaftarKonselingController(),
    );
  }
}
