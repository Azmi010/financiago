import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/challange_page/controllers/challange_page_controller.dart';
import 'package:safeloan/app/modules/User/education/models/article_model.dart';
import 'package:safeloan/app/modules/User/education/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EducationController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Timer? watchTimer;
  var videoMarkedAsWatched = false.obs;

  var articleList = <Article>[].obs;
  var videoList = <Video>[].obs;
  String educationDocumentId = 'q02NZjM7bwuOI9RDM226';
  final Rx<YoutubePlayerController?> youtubeController =
      Rx<YoutubePlayerController?>(null);
  final RxBool isFullScreen = false.obs;

  Stream<QuerySnapshot> getArticleList() {
    return firestore
        .collection('educations')
        .doc(educationDocumentId)
        .collection('articles')
        .snapshots();
  }

  void toggleFullScreen(bool isFullScreen) {
    this.isFullScreen.value = isFullScreen;
  }

  void updateArticleList(QuerySnapshot snapshot) {
    articleList.clear();
    articleList
        .addAll(snapshot.docs.map((doc) => Article.fromDocument(doc)).toList());
  }

  Stream<QuerySnapshot> getVideoList() {
    return firestore
        .collection('educations')
        .doc(educationDocumentId)
        .collection('videos')
        .snapshots();
  }

  void updateVideoList(QuerySnapshot snapshot) {
    videoList.clear();
    videoList
        .addAll(snapshot.docs.map((doc) => Video.fromDocument(doc)).toList());
  }

  void initializeYoutubePlayer(String videoId) {
    youtubeController.value = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  Future<void> markArticleAsRead(String articleId, String userId) async {
    DocumentReference articleRef = firestore
        .collection('educations')
        .doc(educationDocumentId)
        .collection('articles')
        .doc(articleId);

    await articleRef.collection('readBy').doc(userId).set({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('readArticle')
        .doc(articleId)
        .set({
      'readAt': FieldValue.serverTimestamp(),
    });

    final challengeController = Get.put(ChallangePageController());
    await challengeController.checkAndCompleteChallenges();
  }

  Future<void> markVideoAsWatch(String videoId, String userId) async {
    if (videoMarkedAsWatched.value) return;

    DocumentReference videoRef = firestore
        .collection('educations')
        .doc(educationDocumentId)
        .collection('videos')
        .doc(videoId);

    await videoRef.collection('watchBy').doc(userId).set({
      'isWatch': true,
      'watchAt': FieldValue.serverTimestamp(),
    });

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('watchVideo')
        .doc(videoId)
        .set({
      'watchAt': FieldValue.serverTimestamp(),
    });

    final challengeController = Get.put(ChallangePageController());
    await challengeController.checkAndCompleteChallenges();

    videoMarkedAsWatched.value = true;
  }

  void resetVideoWatchStatus() {
    videoMarkedAsWatched.value = false;
    watchTimer?.cancel();
    watchTimer = null;
  }

  String extractVideoId(String url) {
    final Uri uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    return '';
  }

  @override
  void onClose() {
    youtubeController.value?.dispose();
    watchTimer?.cancel();
    super.onClose();
  }
}
