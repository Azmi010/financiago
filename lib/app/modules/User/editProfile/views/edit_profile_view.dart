import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/profile/controllers/profile_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text('Edit Profil', style: Utils.header),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueAccent.withOpacity(0.3),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Obx(() {
                      final imageUrl = profileController.profileImageUrl.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        child: imageUrl.isEmpty
                            ? Icon(Icons.person,
                                size: 50, color: Colors.grey[200])
                            : null,
                      );
                    }),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: Get.width * 0.27,
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Utils.biruTiga,
                          width: 2,
                        )),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 20, color: Utils.biruLima,),
                      onPressed: () => profileController.updateProfileImage(context),
                      constraints:
                          const BoxConstraints.tightFor(width: 40, height: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildListTileTextField(
              icon: Icons.person,
              label: 'Nama Lengkap',
              controller: controller.fullNameController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            _buildListTileTextField(
              icon: Icons.calendar_today,
              label: 'Umur',
              controller: controller.ageController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildListTileTextField(
              icon: Icons.work,
              label: 'Profesi',
              controller: controller.professionController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonWidget(
                onPressed: () => controller.saveProfile(context),
                nama: "Simpan",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListTileTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
