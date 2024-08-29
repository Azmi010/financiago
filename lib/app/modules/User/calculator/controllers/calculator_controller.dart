import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class CalculatorController extends GetxController {
  final incomeController = TextEditingController();
  final expenseController = TextEditingController();
  final loanAmountController = TextEditingController();
  final interestRateController = TextEditingController();
  final tenorController = TextEditingController();

  final incomeValue = 0.0.obs;
  final formattedIncomeValue = '0'.obs;

  final expenseValue = 0.0.obs;
  final formattedExpenseValue = '0'.obs;

  final tenorValue = 12.obs;
  final formattedTenorValue = '12'.obs;

  final loanAmountValue = 0.0.obs;
  final formattedLoanAmountValue = '0'.obs;

  final interestRateValue = 0.0.obs;
  final formattedInterestRateValue = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    updateFormattedIncomeValue(incomeValue.value);
    updateFormattedExpenseValue(expenseValue.value);
    updateFormattedTenorValue(tenorValue.value);
    updateFormattedLoanAmountValue(loanAmountValue.value);
    updateFormattedInterestRateValue(interestRateValue.value);
  }

  void updateIncomeFromSlider(double value) {
    if (value >= 0 && value <= 100000000) {
      incomeValue.value = value;
      updateFormattedIncomeValue(value);
    }
  }

  void updateIncomeFromTextField(String value) {
    _updateValueFromTextField(value, incomeValue, updateFormattedIncomeValue,
        max: 100000000);
  }

  void updateExpenseFromSlider(double value) {
    expenseValue.value = value;
    updateFormattedExpenseValue(value);
  }

  void updateExpenseFromTextField(String value) {
    _updateValueFromTextField(value, expenseValue, updateFormattedExpenseValue,
        max: 100000000);
  }

  void updateTenorFromSlider(double value) {
    tenorValue.value = value.toInt();
    updateFormattedTenorValue(value.toInt());
  }

  void updateTenorFromTextField(String value) {
    String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isNotEmpty) {
      int intValue = int.parse(numericValue);
      if (intValue >= 1 && intValue <= 360) {
        tenorValue.value = intValue;
        updateFormattedTenorValue(intValue);
      }
    }
  }

  void updateLoanAmountFromTextField(String value) {
    _updateValueFromTextField(
        value, loanAmountValue, updateFormattedLoanAmountValue);
  }

  void updateInterestRateFromTextField(String value) {
    _updateValueFromTextField(
        value, interestRateValue, updateFormattedInterestRateValue,
        max: 100);
  }

  void _updateValueFromTextField(
      String value, RxDouble rxValue, Function(double) updateFormatted,
      {double max = 100000000}) {
    String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isNotEmpty) {
      double doubleValue = double.parse(numericValue);
      if (doubleValue >= 0 && doubleValue <= max) {
        rxValue.value = doubleValue;
        updateFormatted(doubleValue);
      }
    }
  }

  void updateFormattedIncomeValue(double value) {
    formattedIncomeValue.value = formatCurrency(value);
    incomeController.text = formattedIncomeValue.value;
  }

  void updateFormattedExpenseValue(double value) {
    formattedExpenseValue.value = formatCurrency(value);
    expenseController.text = formattedExpenseValue.value;
  }

  void updateFormattedTenorValue(int value) {
    formattedTenorValue.value = value.toString();
    tenorController.text = formattedTenorValue.value;
  }

  void updateFormattedLoanAmountValue(double value) {
    formattedLoanAmountValue.value = formatCurrency(value);
    loanAmountController.text = formattedLoanAmountValue.value;
  }

  void updateFormattedInterestRateValue(double value) {
    formattedInterestRateValue.value = value.toStringAsFixed(2);
    interestRateController.text = formattedInterestRateValue.value;
  }

  String formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void calculateLoan(BuildContext context) {
    try {
      double income = incomeValue.value;
      double expense = expenseValue.value;
      double loanAmount = loanAmountValue.value;
      double interestRate = interestRateValue.value;
      int tenor = tenorValue.value;

      if (expense > income) {
        showDialogInfoWidget(
            'Pengeluaran melebihi penghasilan', 'fail', context);
        return;
      }

      if (tenor == 0 || loanAmount == 0) {
        showDialogInfoWidget(
            'Nilai pinjaman, bunga, atau tenor tidak boleh nol', 'fail', context);
        return;
      }

      if(interestRate > 0){
        showDialogInfoWidget(
            'Pinjaman tidak sehat', 'fail', context);
        return;
      }

      double monthlyInterestRate = interestRate / 12 / 100;
      double monthlyInstallment = (loanAmount * monthlyInterestRate) /
          (1 - pow(1 + monthlyInterestRate, -tenor));
      double remainingIncome = income - expense;

      if (remainingIncome < monthlyInstallment) {
        showDialogInfoWidget(
            'Penghasilan tidak cukup untuk membayar cicilan', 'fail', context);
        return;
      }

      if (remainingIncome > (monthlyInstallment + (income * 0.1))) {
        showDialogInfoWidget(
            'Pinjaman terlihat sehat', 'succes', context);
      } else {
        showDialogInfoWidget(
            'Pinjaman tidak sehat', 'succes', context);
      }

      double totalRepayment = monthlyInstallment * tenor;
      double totalInterest = totalRepayment - loanAmount;

      if (totalInterest > loanAmount) {
        showDialogInfoWidget(
            'Total bunga lebih besar dari jumlah pinjaman', 'fail', context);
      } else {
        showDialogInfoWidget(
            'Total bunga tidak melebihi jumlah pinjaman', 'succes', context);
      }

      if (monthlyInstallment > (income * 0.3)) {
        showDialogInfoWidget(
            'Cicilan bulanan melebihi 30% dari penghasilan bulanan', 'fail', context);
      } else {
        showDialogInfoWidget(
            'Cicilan bulanan tidak melebihi 30% dari penghasilan bulanan', 'succes', context);
      }
    } catch (e) {
      showDialogInfoWidget(
            'Terjadi kesalahan dalam perhitungan', 'fail', context);
    }
  }

  @override
  void onClose() {
    incomeController.dispose();
    expenseController.dispose();
    loanAmountController.dispose();
    interestRateController.dispose();
    tenorController.dispose();
    super.onClose();
  }
}
