import 'package:get/get.dart';

import '../controllers/edit_article_admin_controller.dart';

class EditArticleAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditArticleAdminController>(
      () => EditArticleAdminController(),
    );
  }
}
