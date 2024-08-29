import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/tab_bar_widget.dart';
import '../controllers/education_admin_controller.dart';

class EducationAdminView extends GetView<EducationAdminController> {
  const EducationAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final EducationAdminController educationAdminController =
        Get.put(EducationAdminController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edukasi",
            style: Utils.header,
          ),
          centerTitle: true,
        ),
        body: TabBarWidget(
          views: [
            _buildArticlesTab(context),
            _buildVideosTab(context),
          ],
          tabLabels: const ["Membuat Artikel", "Membuat Video"],
        ),
      ),
    );
  }

  Widget _buildArticlesTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(controller.articleTitleC, 1, 'Judul'),
            _buildTextField(controller.articleContentC, 5, 'Konten'),
            _buildTextField(controller.articleSourceC, 1, 'Sumber'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              width: Get.width,
              height: 150,
              child: GestureDetector(
                onTap: () => controller.pickImage(),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 30,
                      color: Colors.grey,
                    ),
                    Text('Unggah Gambar')
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ButtonWidget(
              onPressed: () {
                controller.addArticle();
              },
              nama: "Tambah Artikel",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(controller.videoTitleC, 1, 'Judul'),
            _buildTextField(controller.videoDescriptionC, 3, 'Deskripsi'),
            _buildTextField(controller.videoLinkC, 1, 'Tautan'),
            _buildTextField(controller.videoLinkC, 1, 'Sumber'),
            const SizedBox(height: 20),
            ButtonWidget(
              onPressed: () {
                controller.addVideo();
              },
              nama: "Tambah Video",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, int maxLines, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Utils.backgroundCard),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Utils.biruDua),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() {
      return Stack(
        children: [
          controller.articleImage.value != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(controller.articleImage.value!.path),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Utils.backgroundCard.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Utils.backgroundCard),
                  ),
                  child: const Center(
                    child: Text('No image selected',
                        style: TextStyle(color: Utils.backgroundCard)),
                  ),
                ),
          Positioned(
            bottom: 8,
            right: 8,
            child: ElevatedButton(
              onPressed: () => controller.pickImage(),
              child: const Text('Pick Image'),
            ),
          ),
        ],
      );
    });
  }
}
