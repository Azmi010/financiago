import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';

import '../controllers/profile_konselor_controller.dart';

class ProfileKonselorView extends GetView<ProfileKonselorController> {
  const ProfileKonselorView({super.key});

  Widget buildListTile({
    required IconData leadingIcon,
    required String titleText,
    VoidCallback? onTap,
    String? subtitleText,
    Color leadingIconColor = Colors.black,
    Color backgroundColor = Utils.biruTiga,
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
    final ProfileKonselorController controller = Get.put(ProfileKonselorController());
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
              margin: const EdgeInsets.all(25),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Utils.biruTiga,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Obx(() {
                        final imageUrl =
                            controller.profileImageUrl.value;
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
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Utils.biruSatu,
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
                    .doc(controller.auth.currentUser!.uid)
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
                        leadingIconColor: Colors.white,
                      ),
                      buildListTile(
                        leadingIcon: Icons.email,
                        titleText: 'Email Address',
                        subtitleText: userData['email'],
                        leadingIconColor: Colors.white,
                      ),
                      buildListTile(
                        leadingIcon: Icons.work,
                        titleText: 'Profession',
                        subtitleText: userData['profession'],
                        leadingIconColor: Colors.white,
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
                    onTap: () => controller.deleteAccount(context),
                    leadingIcon: Icons.delete_forever,
                    titleText: 'Hapus Akun',
                    backgroundColor: Colors.red,
                    leadingIconColor: Colors.white,
                  ),
                  const SizedBox(height: 10,),
                  buildListTile(
                    onTap: () => controller.logout(context),
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
