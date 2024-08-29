import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/input_admin_widget.dart';
import '../controllers/edit_challenge_admin_controller.dart';

class EditChallengeAdminView extends GetView<EditChallengeAdminController> {
  const EditChallengeAdminView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final EditChallengeAdminController editChallengeAdminController = Get.put(EditChallengeAdminController());
    final String challengeId = Get.parameters['id'] ?? '';

    if (challengeId.isNotEmpty) {
      editChallengeAdminController.fetchChallengeData(challengeId);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text('Edit Tantangan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inputAdminWidget(editChallengeAdminController.challengeTitleC, 'Judul'),
              inputAdminWidget(editChallengeAdminController.challengeSubTitleC, 'Sub Judul'),
              inputAdminWidget(editChallengeAdminController.challengeDescriptionC, 'Deskripsi Tantangan'),
              inputAdminWidget(editChallengeAdminController.challengePointC, 'Poin'),
              inputAdminWidget(editChallengeAdminController.challengeTargetC, 'Target'),
              const SizedBox(height: 40),
              ButtonWidget(
                onPressed: () {
                  if (challengeId.isNotEmpty) {
                    editChallengeAdminController.updateChallenge(challengeId).then((_) {
                      Get.back();
                      Get.snackbar('Success', 'Challenge updated successfully');
                    }).catchError((e) {
                      Get.snackbar('Error', 'Failed to update challenge');
                    });
                  }
                },
                nama: "Simpan",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
