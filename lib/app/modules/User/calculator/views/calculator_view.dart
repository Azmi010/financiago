import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/calculator_controller.dart';

class CalculatorView extends GetView<CalculatorController> {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalkulator Simulasi',
          style: Utils.header
        ),
        leading: const ButtonBackLeading(),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(
                        Routes.PINJOL_LIST); // Navigate to PinjolListView
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.list, 
                        color: Utils.biruDua,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Cek Data Pinjol',
                        style: TextStyle(
                          color: Utils.biruDua,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildTextField(
                'Jumlah Penghasilan Perbulan',
                '0',
                controller.formattedIncomeValue,
                controller.incomeValue,
                controller.updateIncomeFromTextField,
                controller.updateIncomeFromSlider,
                Icons.arrow_circle_up,
                Colors.green,
                prefix: 'Rp ',
              ),
              _buildTextField(
                'Jumlah Pengeluaran Perbulan',
                '0',
                controller.formattedExpenseValue,
                controller.expenseValue,
                controller.updateExpenseFromTextField,
                controller.updateExpenseFromSlider,
                Icons.arrow_circle_down,
                Colors.red,
                prefix: 'Rp ',
              ),
              _buildTextFieldNoSlider(
                'Jumlah Pinjaman',
                '0',
                controller.formattedLoanAmountValue,
                controller.loanAmountValue,
                controller.updateLoanAmountFromTextField,
                null,
                Icons.monetization_on,
                Colors.blue,
                prefix: 'Rp ',
              ),
              _buildTextFieldNoSlider(
                'Suku Bunga',
                '0',
                controller.formattedInterestRateValue,
                controller.interestRateValue,
                controller.updateInterestRateFromTextField,
                null,
                Icons.percent,
                Colors.orange,
                suffix: '%',
                max: 100,
              ),
              _buildTextFieldTenor(
                'Tenor Pinjaman',
                '12',
                controller.formattedTenorValue,
                controller.tenorValue,
                controller.updateTenorFromTextField,
                controller.updateTenorFromSlider,
                Icons.calendar_today,
                Colors.purple,
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                  onPressed: () => controller.calculateLoan(context), nama: "Kalkulasi"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String title,
    String hintText,
    RxString formattedValue,
    RxDouble sliderValue,
    Function(String) onTextFieldChanged,
    Function(double)? onSliderChanged,
    IconData icon,
    Color iconColor, {
    String? prefix,
    String? suffix,
    double min = 0,
    double max = 100000000,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (prefix != null)
                Text(prefix, style: const TextStyle(fontSize: 24)),
              Expanded(
                child: Obx(() => TextField(
                      style: const TextStyle(fontSize: 24),
                      controller:
                          TextEditingController(text: formattedValue.value),
                      decoration: InputDecoration(hintText: hintText),
                      keyboardType: TextInputType.number,
                      onChanged: onTextFieldChanged,
                    )),
              ),
              if (suffix != null)
                Text(suffix, style: const TextStyle(fontSize: 24)),
            ],
          ),
          if (onSliderChanged != null) ...[
            const SizedBox(height: 8),
            Obx(() => Slider(
                  inactiveColor: Utils.biruDua,
                  activeColor: Utils.biruSatu,
                  value: sliderValue.value,
                  min: min,
                  max: max,
                  onChanged: onSliderChanged,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${prefix ?? ''}${min.toInt()}",
                    style: TextStyle(color: Colors.grey[600])),
                Text("${prefix ?? ''}${max.toInt()}",
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextFieldNoSlider(
    String title,
    String hintText,
    RxString formattedValue,
    RxDouble sliderValue,
    Function(String) onTextFieldChanged,
    Function(double)? onSliderChanged,
    IconData icon,
    Color iconColor, {
    String? prefix,
    String? suffix,
    double min = 0,
    double max = 100000000,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (prefix != null)
                Text(prefix, style: const TextStyle(fontSize: 24)),
              Expanded(
                  child: TextField(
                style: const TextStyle(fontSize: 24),
                controller: TextEditingController(text: formattedValue.value),
                decoration: InputDecoration(hintText: hintText),
                keyboardType: TextInputType.number,
                onChanged: onTextFieldChanged,
              )),
              if (suffix != null)
                Text(suffix, style: const TextStyle(fontSize: 24)),
            ],
          ),
          if (onSliderChanged != null) ...[
            const SizedBox(height: 8),
            Obx(() => Slider(
                  inactiveColor: Utils.biruDua,
                  activeColor: Utils.biruSatu,
                  value: sliderValue.value,
                  min: min,
                  max: max,
                  onChanged: onSliderChanged,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${prefix ?? ''}${min.toInt()}",
                    style: TextStyle(color: Colors.grey[600])),
                Text("${prefix ?? ''}${max.toInt()}",
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextFieldTenor(
    String title,
    String hintText,
    RxString formattedValue,
    RxInt sliderValue,
    Function(String) onTextFieldChanged,
    Function(double) onSliderChanged,
    IconData icon,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Obx(() => TextField(
                      style: const TextStyle(fontSize: 24),
                      controller:
                          TextEditingController(text: formattedValue.value),
                      decoration: InputDecoration(hintText: hintText),
                      keyboardType: TextInputType.number,
                      onChanged: onTextFieldChanged,
                    )),
              ),
              const SizedBox(width: 10),
              const Text(
                "bulan",
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Slider(
                inactiveColor: Utils.biruDua,
                activeColor: Utils.biruSatu,
                value: sliderValue.value.toDouble(),
                min: 1,
                max: 360,
                onChanged: onSliderChanged,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("1 bulan", style: TextStyle(color: Colors.grey[600])),
              Text("360 bulan", style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
