import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import this package for date formatting

import '../../controllers/finance_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/input_akun_widget.dart';

class ExpenseView extends GetView<FinanceController> {
  final TextEditingController titleC = TextEditingController();
  final TextEditingController nominalC = TextEditingController();
  final TextEditingController dateC = TextEditingController();
  final TextEditingController notesC = TextEditingController();
  final ValueNotifier<String> selectedCategory = ValueNotifier<String>('');

  ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.put(FinanceController());
    var lebar = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pengeluaran",
          style: Utils.header,
        ),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InputAkunWidget(
              nama: 'Judul',
              hintText: 'Masukkan judul pengeluaran',
              leadingIcon: Icons.assignment,
              controller: titleC,
            ),
            InputAkunWidget(
              nama: 'Nominal',
              hintText: '0',
              leadingIcon: Icons.attach_money,
              controller: nominalC,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: lebar, right: lebar),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryColumn(
                          category: 'Darurat',
                          icon: Icons.emergency,
                          selectedCategory: selectedCategory,
                        ),
                        _buildCategoryColumn(
                          category: 'Pangan',
                          icon: Icons.restaurant,
                          selectedCategory: selectedCategory,
                        ),
                        _buildCategoryColumn(
                          category: 'Pakaian',
                          icon: Icons.shopping_bag,
                          selectedCategory: selectedCategory,
                        ),
                        _buildCategoryColumn(
                          category: 'Hiburan',
                          icon: Icons.movie,
                          selectedCategory: selectedCategory,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryColumn(
                          category: 'Pendidikan',
                          icon: Icons.school,
                          selectedCategory: selectedCategory,
                        ),
                        _buildCategoryColumn(
                          category: 'Kesehatan',
                          icon: Icons.local_hospital,
                          selectedCategory: selectedCategory,
                        ),
                        _buildCategoryColumn(
                          category: 'Cicilan',
                          icon: Icons.payment,
                          selectedCategory: selectedCategory,
                        ),
                        _buildCategoryColumn(
                          category: 'Rumahan',
                          icon: Icons.home,
                          selectedCategory: selectedCategory,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InputAkunWidget(
              nama: 'Tanggal',
              hintText: '15/07/2024',
              leadingIcon: Icons.date_range,
              controller: dateC,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  dateC.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 10),
            InputAkunWidget(
              nama: 'Catatan',
              hintText: 'Masukkan Catatan',
              leadingIcon: Icons.assignment,
              controller: notesC,
            ),
            const SizedBox(height: 30),
            ButtonWidget(
              onPressed: () {
                String title = titleC.text;
                String nominalText = nominalC.text;
                String dateText = dateC.text;
                String notes = notesC.text;
                String category = selectedCategory.value;

                if (title.isEmpty || nominalText.isEmpty ||
                    dateText.isEmpty ||
                    category.isEmpty ||
                    notes.isEmpty) {
                  Get.snackbar('Error', 'All fields are required');
                } else {
                  double? nominal = double.tryParse(nominalText);
                  if (nominal == null) {
                    Get.snackbar('Error', 'Invalid nominal amount');
                    return;
                  }
                  DateTime? date;
                  try {
                    date = DateFormat('dd/MM/yyyy').parse(dateText);
                  } catch (e) {
                    Get.snackbar('Error', 'Invalid date format');
                    return;
                  }

                  controller.confirmAddExpense(
                      context, title, nominal, category, date, notes);
                }
              },
              nama: 'Tambah',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryColumn({
    required String category,
    required IconData icon,
    required ValueNotifier<String> selectedCategory,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedCategory,
      builder: (context, value, child) {
        bool isSelected = value == category;
        return GestureDetector(
          onTap: () {
            selectedCategory.value = category;
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Utils.biruLima : Colors.transparent,
                  border: Border.all(
                      color: isSelected ? Utils.biruEmpat : Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 35,
                  color: isSelected ? Utils.biruDua : Colors.black,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Utils.biruDua : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
