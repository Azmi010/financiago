import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/counseling/models/counseling.dart';
import 'package:safeloan/app/utils/warna.dart';
import '../controllers/edit_jadwal_controller.dart';

class EditJadwalView extends GetView<EditJadwalController> {
  const EditJadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    final EditJadwalController scheduleController =
        Get.put(EditJadwalController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atur Jadwal',
          style: Utils.header,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: scheduleController.getAllSchedule(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No schedule found.'));
              }

              scheduleController.updateCounselingList(snapshot.data!);

              return Obx(() {
                if (scheduleController.counselingList.isEmpty) {
                  return const Center(child: Text('No schedule found.'));
                }

                return ListView.builder(
                  itemCount: scheduleController.counselingList.length,
                  itemBuilder: (context, index) {
                    CounselingSession counseling =
                        scheduleController.counselingList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Utils.backgroundCard,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Utils.biruDua,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${counseling.durasi.toString()} menit",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    counseling.jadwal.toString().split(' ')[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    counseling.tautanGmeet,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Utils.biruDua),
                              onPressed: () {
                                _showEditScheduleDialog(context, counseling);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                scheduleController
                                    .deleteSchedule(counseling.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _showAddScheduleDialog(context);
              },
              backgroundColor: Utils.biruSatu,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAddScheduleDialog(BuildContext context) {
  final EditJadwalController scheduleController =
      Get.put(EditJadwalController());
  final TextEditingController dateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Tambah Jadwal Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Jadwal',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Durasi (menit)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: 'Link Google Meet',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final DateTime? jadwal = DateTime.tryParse(dateController.text);
              final int durasi = int.tryParse(durationController.text) ?? 0;
              final String tautanGmeet = linkController.text;

              if (jadwal != null) {
                scheduleController.addSchedule(jadwal, durasi, tautanGmeet);
                Navigator.of(context).pop();
              } else {
                Get.snackbar('Error', 'Tanggal tidak valid');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Utils.biruSatu,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void _showEditScheduleDialog(BuildContext context, CounselingSession schedule) {
  final EditJadwalController scheduleController =
      Get.put(EditJadwalController());
  final TextEditingController dateController =
      TextEditingController(text: schedule.jadwal.toString().split(' ')[0]);
  final TextEditingController durationController =
      TextEditingController(text: schedule.durasi.toString());
  final TextEditingController linkController =
      TextEditingController(text: schedule.tautanGmeet);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Edit Jadwal',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Jadwal',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Durasi (menit)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: 'Link Google Meet',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final DateTime? jadwal = DateTime.tryParse(dateController.text);
              final int durasi = int.tryParse(durationController.text) ?? 0;
              final String tautanGmeet = linkController.text;

              if (jadwal != null) {
                scheduleController.updateSchedule(
                    schedule.id, jadwal, durasi, tautanGmeet);
                Navigator.of(context).pop();
              } else {
                Get.snackbar('Error', 'Tanggal tidak valid');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Utils.biruSatu,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
