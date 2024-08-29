import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/input_admin_widget.dart';
import '../controllers/edit_video_admin_controller.dart';

class EditVideoAdminView extends GetView<EditVideoAdminController> {
  const EditVideoAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    EditVideoAdminController controller = Get.put(EditVideoAdminController());
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text('Daftar Video', style: Utils.header),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: controller.getVideosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No videos found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var video = snapshot.data!.docs[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 0.6, horizontal: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
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
                  child: ListTile(
                    title: Text(
                      video['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      video['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editVideo(video);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.deleteVideo(video.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editVideo(DocumentSnapshot video) {
    TextEditingController titleController =
        TextEditingController(text: video['title']);
    TextEditingController descriptionController =
        TextEditingController(text: video['description']);
    TextEditingController linkController =
        TextEditingController(text: video['link']);

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Video"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inputAdminWidget(titleController, 'Judul'),
              inputAdminWidget(descriptionController, 'Deskripsi'),
              inputAdminWidget(linkController, 'Tautan'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.editVideo(video.id, {
                'title': titleController.text,
                'content': descriptionController.text,
                'source': linkController.text,
              });
              Get.back();
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
