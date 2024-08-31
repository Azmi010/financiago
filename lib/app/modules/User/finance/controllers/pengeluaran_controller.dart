import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../views/widgets/expense_view.dart';
import 'finance_controller.dart';

class PengeluaranController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  late final GenerativeModel _model;
  final FinanceController controller = Get.put(FinanceController());

  FirebaseAuth get auth => _auth;

  var expenseList = <Map<String, dynamic>>[].obs;
  var totalExpenses = 0.0.obs;
  var selectedFilter = 'Semua Data'.obs;

  final titleC = TextEditingController();
  final nominalC = TextEditingController();
  final dateC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    listenToExpenseData();
    _initializeGemini();
  }

  void _initializeGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    _model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey!);
  }

  void listenToExpenseData() {
    String uid = _auth.currentUser!.uid;
    CollectionReference expenseCollection =
        _firestore.collection('finances').doc(uid).collection('expense');

    expenseCollection.snapshots().listen((snapshot) {
      var expenseDocs = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate();
        }
        data['docId'] = doc.id;
        return data;
      }).toList();

      expenseDocs.sort((a, b) {
        DateTime dateA = a['date'] is DateTime
            ? a['date'] as DateTime
            : DateTime.parse(a['date'].toString());
        DateTime dateB = b['date'] is DateTime
            ? b['date'] as DateTime
            : DateTime.parse(b['date'].toString());
        return dateB.compareTo(dateA);
      });

      List<Map<String, dynamic>> filteredDocs = _filterData(expenseDocs);

      expenseList.value = filteredDocs;
      totalExpenses.value = filteredDocs.fold(
          0.0, (sum, item) => sum + (item['nominal'] as num).toDouble());
    });
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedFilter.value) {
      case 'Harian':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Mingguan':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Bulanan':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Tahunan':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        return data;
    }

    return data.where((item) {
      DateTime itemDate = item['date'] is DateTime
          ? item['date'] as DateTime
          : DateTime.parse(item['date'].toString());
      return itemDate.isAfter(startDate);
    }).toList();
  }

  Future<void> analyzeImage(File imageFile, bool includeCategory) async {
    try {
      // Construct the prompt dynamically
      String prompt;
      if (includeCategory) {
        prompt =
            "Analyze this receipt image and extract the following information: "
            "1. The title or main item of the expense. "
            "2. The total amount spent. "
            "3. The date of the expense in the format 'yyyy-MM-dd'. "
            "4. The category of the expense from the following list: "
            "Darurat, Pangan, Pakaian, Hiburan, Pendidikan, Kesehatan, Cicilan, Rumahan. "
            "Please format the response as: Title: [title], Amount: [amount], Date: [yyyy-MM-dd], Category: [category]. "
            "If the extracted category is not in the list, please default to 'Uncategorized'.";
      } else {
        prompt =
            "Analyze this receipt image and extract the following information: "
            "1. The title or main item of the expense. "
            "2. The total amount spent. "
            "3. The date of the expense in the format 'yyyy-MM-dd'. "
            "Please format the response as: Title: [title], Amount: [amount], Date: [yyyy-MM-dd].";
      }

      final imageBytes = await imageFile.readAsBytes();

      final promptText = TextPart(prompt);
      final imageParts = [DataPart('image/jpeg', imageBytes)];

      final response = await _model.generateContent([
        Content.multi([promptText, ...imageParts])
      ]);
      final responseText = response.text;

      print('Response Text:');
      print(responseText);

      final regexString = includeCategory
          ? r'Title:\s*(.*?),\s*Amount:\s*([\d.,]+),\s*Date:\s*(\d{4}-\d{2}-\d{2}),\s*Category:\s*(.*)'
          : r'Title:\s*(.*?),\s*Amount:\s*([\d.,]+),\s*Date:\s*(\d{4}-\d{2}-\d{2})';
      final regex = RegExp(regexString, caseSensitive: false);

      final match = regex.firstMatch(responseText ?? '');

      if (match != null) {
        String title = match.group(1)?.trim() ?? '';
        String nominal = match.group(2)?.trim() ?? '';
        String dateStr = match.group(3)?.trim() ?? '';
        String category =
            includeCategory ? (match.group(4)?.trim() ?? 'Uncategorized') : '';

        nominal = nominal.replaceAll('.', '');

        print('Extracted Title: $title');
        print('Extracted Nominal: $nominal');
        print('Extracted Date: $dateStr');
        if (includeCategory) {
          category = category.replaceAll('.', '').trim();

          print('Extracted Category: $category');
          List<String> validCategories = [
            'Darurat',
            'Pangan',
            'Pakaian',
            'Hiburan',
            'Pendidikan',
            'Kesehatan',
            'Cicilan',
            'Rumahan'
          ];
          if (!validCategories.contains(category)) {
            category = 'Uncategorized';
          }
        }

        DateTime? date;
        try {
          date = DateTime.parse(dateStr);
        } catch (e) {
          print('Error parsing date: $e');
          Get.snackbar('Error', 'Failed to parse the date from the image');
          return;
        }

        Get.to(() => ExpenseView(), arguments: {
          'title': title,
          'nominal': nominal,
          'date': date,
          'category': includeCategory ? category : null,
        });
      } else {
        print('No match found');
        Get.snackbar('Error', 'Failed to extract information from the image');
      }
    } catch (e) {
      print('Error analyzing image: $e');
      Get.snackbar('Error', 'Failed to analyze image');
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        bool includeCategory = true;
        await analyzeImage(File(image.path), includeCategory);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> takeImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        bool includeCategory = true;

        await analyzeImage(File(image.path), includeCategory);
      }
    } catch (e) {
      print('Error taking image: $e');
    }
  }
}
