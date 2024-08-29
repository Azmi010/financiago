import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/challange_page/models/challange_model.dart';

class ChallangePageController extends GetxController {
  late User? _currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var challengeList = <Challenge>[].obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> listChallenge() {
    return firestore.collection('challenges').snapshots();
  }

  void updateChallengeList(QuerySnapshot snapshot) {
    challengeList.clear();
    challengeList.addAll(
        snapshot.docs.map((doc) => Challenge.fromDocument(doc)).toList());
  }

  Future<Map<String, dynamic>> getChallengeDetails(String challengeId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error getting challenge details: $e");
      return {};
    }
  }

  Future<bool> isChallengeCompletedByUser(String challengeId) async {
    if (_currentUser == null) return false;

    DocumentReference userRef = firestore
        .collection('challenges')
        .doc(challengeId)
        .collection('completedBy')
        .doc(_currentUser!.uid);

    DocumentSnapshot userSnapshot = await userRef.get();
    return userSnapshot.exists;
  }

  @override
  void onInit() {
    _currentUser = FirebaseAuth.instance.currentUser;
    super.onInit();
  }

  Future<void> checkAndCompleteChallenges() async {
    if (_currentUser == null) {
      return;
    }

    try {
      DocumentReference userRef =
          firestore.collection('users').doc(_currentUser!.uid);

      await _checkChallenges(userRef, 'artikel', 'readArticle');

      await _checkChallenges(userRef, 'video', 'watchVideo');
    } catch (e) {
      print("Error in checkAndCompleteChallenges: $e");
    }
  }

  Future<void> _checkChallenges(DocumentReference userRef, String challengeType,
      String userCollectionName) async {
    QuerySnapshot challengesSnapshot = await firestore
        .collection('challenges')
        .where('category', isEqualTo: challengeType)
        .get();

    QuerySnapshot userItemsSnapshot =
        await userRef.collection(userCollectionName).get();
    int itemCount = userItemsSnapshot.docs.length;

    for (QueryDocumentSnapshot challenge in challengesSnapshot.docs) {
      int requiredCount = challenge['requiredCount'];
      int challengePoints = challenge['point'];
      int challengeCoins = challenge['coin'];
      String challengeId = challenge.id;

      if (itemCount >= requiredCount) {
        bool alreadyCompleted = await isChallengeCompletedByUser(challengeId);

        if (!alreadyCompleted) {
          await firestore
              .collection('challenges')
              .doc(challengeId)
              .collection('completedBy')
              .doc(_currentUser!.uid)
              .set({
            'completedAt': FieldValue.serverTimestamp(),
          });

          await firestore.runTransaction((transaction) async {
            DocumentSnapshot userSnapshot = await transaction.get(userRef);

            if (userSnapshot.exists) {
              Map<String, dynamic> userData =
                  userSnapshot.data() as Map<String, dynamic>;
              int currentPoints = userData['point'] ?? 0;
              int currentCoins = userData['coin'] ?? 0;
              int newPoints = currentPoints + challengePoints;
              int newCoins = currentCoins + challengeCoins;

              transaction
                  .update(userRef, {'point': newPoints, 'coin': newCoins});
            } else {
              print("User document does not exist");
            }
          });
        } else {
          print("Challenge $challengeId already completed");
        }
      } else {
        print(
            "Challenge $challengeId not met ($challengeType count: $itemCount, required: $requiredCount)");
      }
    }
  }

  Future<void> checkAndCompleteFinanceChallenge(DateTime incomeDate) async {
    if (_currentUser == null) return;

    try {
      QuerySnapshot financeChallenge = await firestore
          .collection('challenges')
          .where('category', isEqualTo: 'finance')
          .limit(1)
          .get();

      if (financeChallenge.docs.isEmpty) return;

      DocumentSnapshot challengeDoc = financeChallenge.docs.first;
      String challengeId = challengeDoc.id;
      Map<String, dynamic> challengeData =
          challengeDoc.data() as Map<String, dynamic>;

      String incomeMonthYear =
          '${incomeDate.year}-${incomeDate.month.toString().padLeft(2, '0')}';

      DateTime now = DateTime.now();
      String currentMonthYear =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';

      DocumentReference completionRef = firestore
          .collection('challenges')
          .doc(challengeId)
          .collection('completedBy')
          .doc(_currentUser!.uid);

      DocumentSnapshot completionDoc = await completionRef.get();

      if (incomeMonthYear == currentMonthYear) {
        if (!completionDoc.exists ||
            (completionDoc.data()
                    as Map<String, dynamic>)['lastCompletedMonth'] !=
                currentMonthYear) {
          await completionRef.set({
            'lastCompletedMonth': currentMonthYear,
            'completedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          int challengePoints = challengeData['point'] ?? 0;
          int challengeCoins = challengeData['coin'] ?? 0;

          await updateUserPointsAndCoins(challengePoints, challengeCoins);

          print(
              "Finance challenge completed and rewards added for $currentMonthYear");
        } else {
          print("Finance challenge already completed for this month");
        }
      } else {
        print("Income is not from the current month. Challenge not completed.");
      }
    } catch (e) {
      print("Error in checkAndCompleteFinanceChallenge: $e");
    }
  }

  Future<void> updateUserPointsAndCoins(int pointsToAdd, int coinsToAdd) async {
    DocumentReference userRef =
        firestore.collection('users').doc(_currentUser!.uid);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        int currentPoints = userData['point'] ?? 0;
        int currentCoins = userData['coin'] ?? 0;
        int newPoints = currentPoints + pointsToAdd;
        int newCoins = currentCoins + coinsToAdd;

        transaction.update(userRef, {'point': newPoints, 'coin': newCoins});
        print(
            "User points updated to $newPoints and coins updated to $newCoins");
      } else {
        print("User document does not exist");
      }
    });
  }
}
