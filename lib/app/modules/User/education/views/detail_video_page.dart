import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/education/controllers/education_controller.dart';
import 'package:safeloan/app/modules/User/education/models/video_model.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends GetView<EducationController> {
  final Video video;

  const YouTubePlayerScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final youtubeController = controller.youtubeController.value;
      if (youtubeController == null) {
        return const Center(child: CircularProgressIndicator());
      }

      youtubeController.addListener(() {
        if (youtubeController.value.isPlaying) {
          _startWatchTimer();
        } else if (youtubeController.value.playerState == PlayerState.paused ||
                   youtubeController.value.playerState == PlayerState.ended) {
          _cancelWatchTimer();
        }
      });

      return YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          controller.isFullScreen.value = false;
        },
        onEnterFullScreen: () {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          controller.isFullScreen.value = true;
        },
        player: YoutubePlayer(
          controller: youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Utils.biruDua,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                youtubeController.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                print('Settings Tapped!');
              },
            ),
          ],
          onReady: () {
            print('Player is ready.');
          },
        ),
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(leading: const ButtonBackLeading(), title: const Text("Video", style: Utils.header,), centerTitle: true,),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: controller.isFullScreen.value
                      ? MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height
                      : 16 / 9, // Adjust aspect ratio as needed
                  child: player,
                ),
                if (!controller.isFullScreen.value)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,style: Utils.titleStyle,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            video.description,style: Utils.subtitle,
                          ),
                          Text('Posted: ${video.postAt.toString()}', style: Utils.subtitle,),
                          // Add other video details here
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  void _startWatchTimer() {
    if (!controller.videoMarkedAsWatched.value) {
      controller.watchTimer?.cancel();
      controller.watchTimer = Timer(const Duration(seconds: 10), () {
        if (!controller.videoMarkedAsWatched.value) {
          controller.markVideoAsWatch(video.id, FirebaseAuth.instance.currentUser!.uid);
          controller.videoMarkedAsWatched.value = true;
        }
      });
    }
  }

  void _cancelWatchTimer() {
    controller.watchTimer?.cancel();
  }
}
