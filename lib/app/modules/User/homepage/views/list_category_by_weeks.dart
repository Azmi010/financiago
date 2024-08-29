import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/widgets/category_card.dart';

import '../controllers/list_category_by_week_controller.dart';

class ListCategoryByWeeks extends StatelessWidget {
  const ListCategoryByWeeks({super.key});

  @override
  Widget build(BuildContext context) {
    final WeeklyController controller = Get.put(WeeklyController());

    final incomeIcons = {
      'Gaji': Icons.attach_money,
      'Hadiah': Icons.card_giftcard,
      'Investasi': Icons.trending_up,
      'Freelance': Icons.work,
    };

    final expenseIcons = {
      'Darurat': Icons.warning,
      'Pangan': Icons.fastfood,
      'Pakaian': Icons.shopping_bag,
      'Hiburan': Icons.movie,
      'Pendidikan': Icons.school,
      'Kesehatan': Icons.local_hospital,
      'Cicilan': Icons.credit_card,
      'Rumahan': Icons.home,
    };

    return Obx(() {
      final incomeTotals = controller.incomeTotalsByCategory;
      final expenseTotals = controller.expenseTotalsByCategory;

      List<Widget> categoryCards = [];

      incomeTotals.forEach((category, total) {
        categoryCards.add(CategoryCard(
          icon: incomeIcons[category] ?? Icons.money,
          judul: category,
          nominal: NumberFormat.currency(locale: 'id_ID').format(total),
          colorNominal: Colors.green,
        ));
      });

      expenseTotals.forEach((category, total) {
        categoryCards.add(CategoryCard(
          icon: expenseIcons[category] ?? Icons.shopping_cart,
          judul: category,
          nominal: NumberFormat.currency(locale: 'id_ID').format(total),
          colorNominal: Colors.red,
        ));
      });

      if (categoryCards.isEmpty) {
        return Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Tidak ada data minggu ini',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ),
          );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: categoryCards,
              ),
            ],
          ),
        ),
      );
    });
  }
}
