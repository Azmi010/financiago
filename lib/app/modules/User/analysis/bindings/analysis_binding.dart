import 'package:get/get.dart';

import '../controllers/analysis_controller.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalysisController>(
      () => AnalysisController(),
    );
  }
}
