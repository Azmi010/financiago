import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import '../controllers/counseling_controller.dart';
import '../models/counseling.dart';

class CounselingView extends GetView<CounselingController> {
  const CounselingView({super.key});

  Widget cardItem(
    String linkGambar,
    String namaKonselor,
    String keahlian,
    String tanggal,
    String waktu,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Utils.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "pastikan hadir tepat waktu sesuai sesi yang tersedia",
            style: Utils.subtitle,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(linkGambar),
            ),
            title: Text(
              namaKonselor,
              style: Utils.titleStyle,
            ),
            subtitle: Text(
              keahlian,
              style: Utils.subtitle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.event,
                size: 16,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Tanggal: ",
                style: TextStyle(fontSize: 12, color: Utils.biruSatu),
              ),
              Text(
                tanggal,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
              ),
              const Text(
                " Durasi: ",
                style: TextStyle(fontSize: 12, color: Utils.biruSatu),
              ),
              Text(waktu),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonWidget(onPressed: onPressed, nama: "Tautan Meeting"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CounselingController counselingController =
        Get.put(CounselingController());
    
    return Scaffold(
      body: StreamBuilder<CounselingSessionWithUserData?>(
        stream: counselingController.getCounselingSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Tidak ada sesi konseling.'));
          }

          final session = snapshot.data!;
          final counseling = session.counseling;
          final userData = session.userData;

          return Column(
            children: [
              cardItem(
                userData['profileImageUrl'] ?? '', // Link gambar
                userData['fullName'] ?? 'Nama Konselor',
                userData['profession'] ?? 'Psikolog handal',
                DateFormat.yMMMMd().add_jm().format(counseling.jadwal),
                '${counseling.durasi} menit',
                () async {
                  String meetingUrl = counseling.tautanGmeet;
                  await counselingController.launchURL(meetingUrl);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
