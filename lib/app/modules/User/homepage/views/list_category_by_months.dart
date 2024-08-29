import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/widgets/category_card.dart';

import '../controllers/list_category_by_month_controller.dart';

class ListCategoryByMonths extends StatelessWidget {
  const ListCategoryByMonths({super.key});

  @override
  Widget build(BuildContext context) {
    final MonthlyController controller = Get.put(MonthlyController());

    return Obx(() {
      List<Widget> categoryCards = [];

      controller.incomeTotalsByCategory.forEach((category, total) {
        categoryCards.add(CategoryCard(
          icon: _getIconForCategory(category, true),
          judul: category,
          nominal: NumberFormat.currency(locale: 'id_ID').format(total),
          colorNominal: Colors.green,
        ));
      });

      controller.expenseTotalsByCategory.forEach((category, total) {
        categoryCards.add(CategoryCard(
          icon: _getIconForCategory(category, false),
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
                'Tidak ada data bulan ini',
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

  IconData _getIconForCategory(String category, bool isIncome) {
    switch (category) {
      case 'Gaji':
        return Icons.money;
      case 'Hadiah':
        return Icons.card_giftcard;
      case 'Investasi':
        return Icons.trending_up;
      case 'Freelance':
        return Icons.work;
      case 'Darurat':
        return Icons.warning;
      case 'Pangan':
        return Icons.fastfood;
      case 'Pakaian':
        return Icons.shopping_bag;
      case 'Hiburan':
        return Icons.movie;
      case 'Pendidikan':
        return Icons.school;
      case 'Kesehatan':
        return Icons.local_hospital;
      case 'Cicilan':
        return Icons.payment;
      case 'Rumahan':
        return Icons.home;
      default:
        return isIncome ? Icons.attach_money : Icons.money_off;
    }
  }
}
