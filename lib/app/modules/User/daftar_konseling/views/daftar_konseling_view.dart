import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:safeloan/app/modules/User/counseling/controllers/counseling_controller.dart';
import 'package:safeloan/app/modules/User/counseling/models/counseling.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/confirm_show_dialog_widget.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

import '../controllers/daftar_konseling_controller.dart';

class DaftarKonselingView extends GetView<DaftarKonselingController> {
  const DaftarKonselingView({super.key});

  Widget buttonAjukan(VoidCallback onPressed) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Utils.biruSatu,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          "Ajukan",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget cardItem(String linkGambar, String namaKonselor, String keahlian,
      String tanggal, String waktu, int koin, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(linkGambar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(namaKonselor,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(keahlian, style: Utils.subtitle),
                  ],
                ),
              ),
              _buildKoinWidget(koin),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoRow(Icons.event, "Tanggal: ", tanggal),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.access_time, "Durasi: ", waktu),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: buttonAjukan(onPressed),
          ),
        ],
      ),
    );
  }

  Widget _buildKoinWidget(int koin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/koin.png', height: 16),
          const SizedBox(width: 5),
          Text(
            '$koin',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Utils.biruSatu),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Utils.biruSatu)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CounselingController counselingController =
        Get.put(CounselingController());
    final DaftarKonselingController registCounseling =
        Get.put(DaftarKonselingController());
    return StreamBuilder<List<CounselingSessionWithUserData>>(
      stream: counselingController.getListKonseling(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada sesi konseling.'));
        }
        counselingController.updateCounselingList(snapshot.data!);
        return Obx(() {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: counselingController.counselingList.length,
                  itemBuilder: (context, index) {
                    CounselingSessionWithUserData session =
                        counselingController.counselingList[index];
                    return cardItem(
                        session.userData['profilePicture'] ?? "",
                        session.userData['fullName'],
                        session.userData['profession'],
                        DateFormat.yMMMMd().format(session.counseling.jadwal),
                        '${session.counseling.durasi} menit',
                        50, () {
                      confirmShowDialog(
                          judul: "Apakah kamu ingin ajukan sesi ini seharga 50 coin?",
                          onPressed: () async {
                            Get.back();
                            bool success = await registCounseling
                                .bookSchedule(session.counseling.id);
                            if (success) {
                              showDialogInfoWidget('Daftar konseling sukses.',
                                  'succes', context);
                            } else {
                              showDialogInfoWidget(
                                  "Kamu tidak dapat melakukan booking.",
                                  'fail',
                                  context);
                            }
                          },
                          context: context);
                    });
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
