import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';

import '../controllers/challange_page_controller.dart';

class ChallangePageView extends GetView<ChallangePageController> {
  ChallangePageView({super.key});
  @override
  final ChallangePageController controller = Get.put(ChallangePageController());

  void showChallengeDetails(BuildContext context, String challengeId) async {
    var challengeDetails = await controller.getChallengeDetails(challengeId);

    if (challengeDetails.isNotEmpty) {
      String routeName;
      switch (challengeDetails['category']) {
        case 'artikel':
          routeName = '/education';
          break;
        case 'video':
          routeName = '/education';
          break;
        case 'finance':
          routeName = '/finance';
          break;
        default:
          routeName = '/default';
      }

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            color: Colors.white,
            width: Get.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  title: Text(
                    challengeDetails['title'] ?? 'No Title',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 10),
                Text(challengeDetails['description'] ?? 'No Description'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoColumn(
                        challengeDetails['requiredCount']?.toString() ?? 'N/A',
                        challengeDetails['category']),
                    _buildInfoColumn(
                        challengeDetails['point']?.toString() ?? 'N/A', "Poin"),
                    _buildInfoColumn(challengeDetails['coin']?.toString() ?? 'N/A', "Koin"),
                  ],
                ),
                const SizedBox(height: 40),
                ButtonWidget(
                  onPressed: () => Get.toNamed(
                      routeName),
                  nama: 'Selesaikan Sekarang',
                ),
              ],
            ),
          );
        },
      );
    } else {
      print('error');
    }
  }

  Widget cardItem(
      String challengeId,
      String title,
      String deskripsi,
      IconData icon,
      Color iconColor,
      String imageChallenge,
      BuildContext context) {
    return GestureDetector(
      onTap: () => showChallengeDetails(context, challengeId),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
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
        child: ListTile(
          leading: Image.network(
            imageChallenge,
            width: 50,
            height: 50,
            fit: BoxFit.fitHeight,
          ),
          title: Text(
            title,
            style: Utils.titleStyle,
          ),
          subtitle: Text(
            deskripsi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Utils.subtitle,
          ),
          trailing: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: 100,
      height: 60,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.listChallenge(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No challenges found'));
            }
            controller.updateChallengeList(snapshot.data!);

            return Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: controller.challengeList.length,
                  itemBuilder: (context, index) {
                    var challenge = controller.challengeList[index];

                    return FutureBuilder<bool>(
                      future:
                          controller.isChallengeCompletedByUser(challenge.id),
                      builder: (context, completedSnapshot) {
                        if (completedSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return cardItem(
                            challenge.id,
                            challenge.title,
                            challenge.subTitle,
                            Icons.hourglass_empty,
                            Utils.backgroundCard,
                            challenge.imageChallenge,
                            context,
                          );
                        }
                        if (completedSnapshot.hasData &&
                            completedSnapshot.data == true) {
                          return cardItem(
                            challenge.id,
                            challenge.title,
                            challenge.subTitle,
                            Icons.check_circle,
                            Utils.biruTiga,
                            challenge.imageChallenge,
                            context,
                          );
                        } else {
                          return cardItem(
                            challenge.id,
                            challenge.title,
                            challenge.subTitle,
                            Icons.history,
                            Colors.white,
                            challenge.imageChallenge,
                            context,
                          );
                        }
                      },
                    );
                  },
                ),
              );
            });
          },
        )
      ]),
    );
  }
}
