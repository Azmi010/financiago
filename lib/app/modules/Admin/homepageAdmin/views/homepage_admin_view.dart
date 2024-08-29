import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../controllers/homepage_admin_controller.dart';

class HomepageAdminView extends GetView<HomepageAdminController> {
  const HomepageAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomepageAdminController homepageAdminController = Get.put(HomepageAdminController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda Admin',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Utils.biruDua,
        actions: [
          IconButton(
            onPressed: () => homepageAdminController.logout(),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMenuItem(
              icon: Icons.article,
              label: 'Artikel',
              onTap: () => Get.toNamed('/edit-article-admin'),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.video_library,
              label: 'Video',
              onTap: () => Get.toNamed('/edit-video-admin'),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.quiz,
              label: 'Kuis',
              onTap: () => Get.toNamed('/edit-quiz-admin'),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.flag,
              label: 'Tantangan',
              onTap: () => Get.toNamed('/challenge-admin'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 30,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Utils.biruDua,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Utils.biruSatu,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
