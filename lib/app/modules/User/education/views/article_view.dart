import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/education/controllers/education_controller.dart';
import 'package:safeloan/app/modules/User/education/models/article_model.dart';
import 'package:safeloan/app/modules/User/education/views/detail_article_page.dart';
import 'package:safeloan/app/utils/warna.dart';

class ArticleWidget extends GetView<EducationController> {
  const ArticleWidget({super.key});

  Widget cardItem(Article article, VoidCallback onTap) {
  String previewContent = article.content.split(' ').take(10).join(' ');
  if (article.content.split(' ').length > 10) {
    previewContent += '...';
  }

  return InkWell(
    onTap: onTap,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Penulis: ${article.source}",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: Utils.titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      previewContent,
                      style: Utils.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.image,
                  width: 80,
                  height: 60,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.error, color: Colors.grey[500]),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "${_getTimeAgo(article.postAt)}",
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
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
    stream: educationController.getArticleList(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No articles found.'));
      }

      educationController.updateArticleList(snapshot.data!);

      return Obx(() {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: ListView.builder(
            itemCount: educationController.articleList.length,
            itemBuilder: (context, index) {
              Article article = educationController.articleList[index];
              return cardItem(
                article,
                () {
                  Get.to(DetailArticlePage(article: article));
                },
              );
            },
          ),
        );
      });
    },
  );
}

}
