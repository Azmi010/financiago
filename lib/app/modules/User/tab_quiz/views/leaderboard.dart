import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/profile/controllers/profile_controller.dart';
import 'package:safeloan/app/modules/User/tab_quiz/controllers/tab_quiz_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';

// ignore: must_be_immutable
class LeaderBoard extends GetView<TabQuizController> {
  LeaderBoard({super.key});
  final ProfileController profileController = Get.put(ProfileController());
  
  Widget cardHeader(String deskripsi, String linkGambar, VoidCallback onTap) {
    return Container(
      width: double.infinity,
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
      child: Center(
        child: ListTile(
          subtitle: Text(
            deskripsi,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              linkGambar,
              fit: BoxFit.cover,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TabQuizController controller = Get.put(TabQuizController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: Utils.header,
        ),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: Column(
        children: [
          cardHeader(
            'Ayo selesaikan kuis dan tantangan untuk mengumpulkan poin dan menjadi nomor satu!',
            'assets/images/trophy.png',
            () {},
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: controller.fetchLeaderboardData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final leaderboardData = snapshot.data!;

                return Column(
                  children: [
                    // Top 3 section
                    Container(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTopThreeItem(0, leaderboardData[0]),
                          _buildTopThreeItem(1, leaderboardData[1]),
                          _buildTopThreeItem(2, leaderboardData[2]),
                        ],
                      ),
                    ),
                    // Rest of the list
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 25),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
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
                        child: ListView.builder(
                          itemCount: leaderboardData.length - 3,
                          itemBuilder: (context, index) {
                            return _buildListItem(
                                index + 4, leaderboardData[index + 3]);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeItem(int index, Map<String, dynamic> user) {
    bool isCurrentUser = user['name'] == profileController.userData['fullName'];
    String displayName = isCurrentUser ? 'Anda' : user['name'];

    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[50],
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Utils.biruSatu,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayName,
            style: TextStyle(
              fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              color: isCurrentUser ? Utils.biruDua : Colors.black,
            ),
          ),
          Text(
            '${user['points']} pts',
            style: TextStyle(
              fontSize: 14,
              color: isCurrentUser ? Utils.biruSatu : Colors.grey,
              fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 25),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index, Map<String, dynamic> user) {
    bool isCurrentUser = user['name'] == profileController.userData['fullName'];
    String displayName = isCurrentUser ? 'Anda' : user['name'];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isCurrentUser ? Utils.biruLima : Colors.transparent,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Utils.biruSatu,
          child: Text(
            '$index',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
            color: isCurrentUser ? Utils.biruDua : Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user['points']}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? Utils.biruDua : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 15),
            ),
          ],
        ),
      ),
    );
  }
}
