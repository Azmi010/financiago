import 'package:get/get.dart';

import '../controllers/edit_jadwal_controller.dart';

class EditJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditJadwalController>(
      () => EditJadwalController(),
    );
  }
}
