import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: Utils.header,),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              var notification = controller.notifications[index];
              return NotificationCard(notification: notification);
            },
          );
        }
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        color: Utils.backgroundCard,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          title: Text(
            notification['title'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                notification['description'],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                DateFormat('dd MMMM yyyy, HH:mm').format(
                  (notification['createdAt'] as Timestamp).toDate(),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          leading: const CircleAvatar(
            backgroundColor: Utils.biruEmpat,
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
