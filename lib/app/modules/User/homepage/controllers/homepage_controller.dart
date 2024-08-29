import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeloan/app/modules/User/education/models/article_model.dart';
import 'package:safeloan/app/modules/User/education/views/detail_article_page.dart';

class HomepageController extends GetxController {
  final notifBadgeAmount = 0.obs;
  final showCartBadge = true.obs;
  var todayIncome = <Map<String, dynamic>>[].obs;
  var todayExpenses = <Map<String, dynamic>>[].obs;
  var weeklyIncomeData = <Map<String, dynamic>>[].obs;
  var weeklyExpenseData = <Map<String, dynamic>>[].obs;
  var incomeTotalsByCategory = <String, double>{}.obs;
  var expenseTotalsByCategory = <String, double>{}.obs;
  var monthlyIncomeData = <Map<String, dynamic>>[].obs;
  var monthlyExpenseData = <Map<String, dynamic>>[].obs;
  var points = 1000.obs;
  var currentImageIndex = 0.obs;
  late PageController pageController;

  var income = [1000, 1500, 1200, 1700, 1300].obs;
  var expenses = [800, 1100, 900, 1400, 1000].obs;
  var selectedFilter = 'monthly'.obs;
  var articleImages = <Article>[].obs;

  void startImageSlider() {
    Future.delayed(const Duration(seconds: 3), () {
      if (pageController.hasClients) {
        int nextPage = (pageController.page?.round() ?? 0) + 1;
        if (nextPage >= articleImages.length) {
          nextPage = 0;
        }
        if (pageController.hasClients) {
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
      startImageSlider();
    });
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void navigateToDetailArticle(Article article) {
    Get.to(DetailArticlePage(article: article));
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadArticles();
    fetchTodayData();
    fetchMonthlyData();
    fetchWeeklyData();
    _initializeNotificationListener();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _initializeNotificationListener() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false) 
        .snapshots()
        .listen((snapshot) {
      final unreadCount =
          snapshot.docs.length; 
      notifBadgeAmount.value = unreadCount;
    });
  }

  void markNotificationsAsRead() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final notifications = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in notifications.docs) {
      await doc.reference.update({'read': true});
    }

    notifBadgeAmount.value = 0;
  }

  void loadArticles() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var educationDocumentId = 'q02NZjM7bwuOI9RDM226';
    firestore
        .collection('educations')
        .doc(educationDocumentId)
        .collection('articles')
        .snapshots()
        .listen((snapshot) {
      var articles =
          snapshot.docs.map((doc) => Article.fromDocument(doc)).toList();
      articleImages.assignAll(articles);
      startImageSlider();
    });
  }

  void fetchTodayData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = auth.currentUser!.uid;
    final todayStart = DateTime.now().toUtc().subtract(Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second));
    final todayEnd = todayStart.add(const Duration(days: 1));

    final incomeQuery = firestore
        .collection('finances')
        .doc(uid)
        .collection('income')
        .where('date', isGreaterThanOrEqualTo: todayStart)
        .where('date', isLessThan: todayEnd)
        .snapshots();

    final expenseQuery = firestore
        .collection('finances')
        .doc(uid)
        .collection('expense')
        .where('date', isGreaterThanOrEqualTo: todayStart)
        .where('date', isLessThan: todayEnd)
        .snapshots();

    incomeQuery.listen((snapshot) {
      final incomeData = snapshot.docs.map((doc) => doc.data()).toList();
      todayIncome.assignAll(incomeData);
      calculateTotals(incomeData, true);
    });

    expenseQuery.listen((snapshot) {
      final expenseData = snapshot.docs.map((doc) => doc.data()).toList();
      todayExpenses.assignAll(expenseData);
      calculateTotals(expenseData, false);
    });
  }

  void fetchMonthlyData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = auth.currentUser!.uid;
    final thirtyDaysAgo =
        DateTime.now().subtract(const Duration(days: 30)).toUtc();
    final todayEnd = DateTime.now().toUtc();

    final incomeQuery = firestore
        .collection('finances')
        .doc(uid)
        .collection('income')
        .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo)
        .where('date', isLessThan: todayEnd)
        .snapshots();

    final expenseQuery = firestore
        .collection('finances')
        .doc(uid)
        .collection('expense')
        .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo)
        .where('date', isLessThan: todayEnd)
        .snapshots();

    incomeQuery.listen((snapshot) {
      final incomeData = snapshot.docs.map((doc) => doc.data()).toList();
      monthlyIncomeData.assignAll(incomeData);
      calculateTotalsMonthly(incomeData, true);
    });

    expenseQuery.listen((snapshot) {
      final expenseData = snapshot.docs.map((doc) => doc.data()).toList();
      monthlyExpenseData.assignAll(expenseData);
      calculateTotalsMonthly(expenseData, false);
    });
  }

  void fetchWeeklyData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = auth.currentUser!.uid;
    final today = DateTime.now().toUtc();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final incomeQuery = firestore
        .collection('finances')
        .doc(uid)
        .collection('income')
        .where('date', isGreaterThanOrEqualTo: startOfWeek)
        .where('date', isLessThan: endOfWeek)
        .snapshots();

    final expenseQuery = firestore
        .collection('finances')
        .doc(uid)
        .collection('expense')
        .where('date', isGreaterThanOrEqualTo: startOfWeek)
        .where('date', isLessThan: endOfWeek)
        .snapshots();

    incomeQuery.listen((snapshot) {
      final incomeData = snapshot.docs.map((doc) => doc.data()).toList();
      weeklyIncomeData.assignAll(incomeData);
      calculateTotalsWeekly(incomeData, true);
    });

    expenseQuery.listen((snapshot) {
      final expenseData = snapshot.docs.map((doc) => doc.data()).toList();
      weeklyExpenseData.assignAll(expenseData);
      calculateTotalsWeekly(expenseData, false);
    });
  }

  void calculateTotalsWeekly(List<Map<String, dynamic>> data, bool isIncome) {
    Map<String, double> totalsByCategory = {};

    for (var item in data) {
      String category = item['category'] ?? 'Unknown';
      double nominal = (item['nominal'] as num).toDouble();
      if (totalsByCategory.containsKey(category)) {
        totalsByCategory[category] = totalsByCategory[category]! + nominal;
      } else {
        totalsByCategory[category] = nominal;
      }
    }

    if (isIncome) {
      incomeTotalsByCategory.assignAll(totalsByCategory);
    } else {
      expenseTotalsByCategory.assignAll(totalsByCategory);
    }
  }

  void calculateTotalsMonthly(List<Map<String, dynamic>> data, bool isIncome) {
    Map<String, double> totalsByCategory = {};

    for (var item in data) {
      String category = item['category'] ?? 'Unknown';
      double nominal = (item['nominal'] as num).toDouble();
      if (totalsByCategory.containsKey(category)) {
        totalsByCategory[category] = totalsByCategory[category]! + nominal;
      } else {
        totalsByCategory[category] = nominal;
      }
    }

    if (isIncome) {
      incomeTotalsByCategory.assignAll(totalsByCategory);
    } else {
      expenseTotalsByCategory.assignAll(totalsByCategory);
    }
  }

  void calculateTotals(List<Map<String, dynamic>> data, bool isIncome) {
    Map<String, double> totalsByCategory = {};

    for (var item in data) {
      String category = item['category'] ?? 'Unknown';
      double nominal = (item['nominal'] as num).toDouble();
      if (totalsByCategory.containsKey(category)) {
        totalsByCategory[category] = totalsByCategory[category]! + nominal;
      } else {
        totalsByCategory[category] = nominal;
      }
    }

    if (isIncome) {
      incomeTotalsByCategory.assignAll(totalsByCategory);
    } else {
      expenseTotalsByCategory.assignAll(totalsByCategory);
    }
  }
}
