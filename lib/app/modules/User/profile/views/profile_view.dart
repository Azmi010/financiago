import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  Widget buildListTile({
    required IconData leadingIcon,
    required String titleText,
    VoidCallback? onTap,
    String? subtitleText,
    Color leadingIconColor = Colors.black,
    Color backgroundColor = Utils.biruLima,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(leadingIcon, color: leadingIconColor),
        ),
        title: Text(
          titleText,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitleText != null
            ? Text(subtitleText, style: Utils.subtitle)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: Utils.header,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(25),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueAccent.withOpacity(0.3),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Obx(() {
                        final imageUrl =
                            profileController.profileImageUrl.value;
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
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
                    right: 0,
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
                        onPressed: () => Get.toNamed('/edit-profile'),
                        icon: const Icon(
                          Icons.edit,
                          color: Utils.biruLima,
                        ),
                        constraints: const BoxConstraints.tightFor(
                            width: 30, height: 30),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(profileController.auth.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      buildListTile(
                        leadingIcon: Icons.person,
                        titleText: 'Nama Lengkap',
                        subtitleText: userData['fullName'],
                        leadingIconColor: Utils.biruTiga,
                      ),
                      buildListTile(
                        leadingIcon: Icons.email,
                        titleText: 'Email',
                        subtitleText: userData['email'],
                        leadingIconColor: Utils.biruTiga,
                      ),
                      buildListTile(
                        leadingIcon: Icons.calendar_today,
                        titleText: 'Umur',
                        subtitleText: userData['age']?.toString() ?? "belum ada",
                        leadingIconColor: Utils.biruTiga,
                      ),
                      buildListTile(
                        leadingIcon: Icons.work,
                        titleText: 'Profesi',
                        subtitleText: userData['profession'] ?? "belum ada",
                        leadingIconColor: Utils.biruTiga,
                      ),
                      buildListTile(
                        leadingIcon: Icons.leaderboard,
                        titleText: 'Poin',
                        subtitleText: userData['point']?.toString() ?? '0',
                        leadingIconColor: Utils.biruTiga,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildListTile(
                    onTap: () => profileController.deleteAccount(context),
                    leadingIcon: Icons.delete_forever,
                    titleText: 'Hapus Akun',
                    backgroundColor: Colors.red,
                    leadingIconColor: Colors.white,
                  ),
                  SizedBox(height: 10,),
                  buildListTile(
                    onTap: () => profileController.logout(context),
                    leadingIcon: Icons.logout,
                    titleText: 'Keluar',
                    backgroundColor: Colors.red,
                    leadingIconColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
