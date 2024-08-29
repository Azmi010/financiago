import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/education/controllers/education_controller.dart';
import 'package:safeloan/app/modules/User/education/models/video_model.dart';
import 'package:safeloan/app/modules/User/education/views/detail_video_page.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoWidget extends GetView<EducationController> {
  const VideoWidget({super.key});

  Widget _buildVideoItem(Video video, String videoId, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.network(
            'https://img.youtube.com/vi/${videoId}/mqdefault.jpg',
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                width: double.infinity,
                color: Colors.grey[300],
                child: Icon(Icons.video_library,
                    color: Colors.grey[500], size: 50),
              );
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  ""),
              child: Icon(Icons.person),
            ),
            title: Text(
              video.title,
              style: Utils.titleStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'sumber • ${_getTimeAgo(video.postAt)}',
              style: Utils.subtitle,
            ),
            trailing: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime postTime) {
    Duration difference = DateTime.now().difference(postTime);
    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    final EducationController educationController =
        Get.put(EducationController());

    return StreamBuilder<QuerySnapshot>(
      stream: educationController.getVideoList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No videos found.'));
        }

        educationController.updateVideoList(snapshot.data!);

        return Obx(() {
          return ListView.builder(
            itemCount: educationController.videoList.length,
            itemBuilder: (context, index) {
              Video video = educationController.videoList[index];
              String videoId = educationController.extractVideoId(video.link);
              return _buildVideoItem(
                video,
                videoId,
                () => _navigateToVideoPlayer(context, video),
              );
            },
          );
        });
      },
    );
  }

  void _navigateToVideoPlayer(BuildContext context, Video video) {
    String? videoId = YoutubePlayer.convertUrlToId(video.link);
    if (videoId != null) {
      controller.resetVideoWatchStatus();
      controller.initializeYoutubePlayer(videoId);
      Get.to(() => YouTubePlayerScreen(video: video));
    } else {
      Get.snackbar('Error', 'Invalid YouTube URL');
    }
  }
}
