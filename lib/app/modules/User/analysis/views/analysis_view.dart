import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import '../../analysis_result/controllers/analysis_result_controller.dart';
import '../controllers/analysis_controller.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalysisResultController analysisResultController =
        Get.put(AnalysisResultController());
    final AnalysisController controller = Get.put(AnalysisController());
    // Tambahkan controller untuk animasi

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analisis Keuangan',
          style: Utils.header,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: Get.width * 0.75,
                decoration: BoxDecoration(
                  color: Utils.biruLima,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Hi, aku Kelola-Bot. aku adalah AI yang akan mendampingimu di dalam aplikasi Kelola.In!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 300,
                child: Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(top: controller.offset.value),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Image(
                          fit: BoxFit.cover,
                          width: 250,
                          image: AssetImage('assets/images/maskot.png'),
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                onPressed: () async {
                  try {
                    await analysisResultController.fetchAnalysisResult();
                    analysisResultController.showLoadingAndNavigate();
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error: $e');
                    }
                  }
                },
                nama: 'Analisis',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
