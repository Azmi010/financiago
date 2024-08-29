import 'package:get/get.dart';

import '../controllers/analysis_result_controller.dart';

class AnalysisResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalysisResultController>(
      () => AnalysisResultController(),
    );
  }
}
