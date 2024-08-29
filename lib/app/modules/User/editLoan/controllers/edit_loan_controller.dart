import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditLoanController extends GetxController {
  late TextEditingController namaPinjamanC;
  late TextEditingController jumlahPinjamanC;
  late TextEditingController angsuranC;
  late TextEditingController bungaC;

  final jumlahPinjamanValue = 0.0.obs;
  final formattedJumlahPinjamanValue = '0'.obs;

  final angsuranValue = 1.obs;
  final formattedAngsuranValue = '1'.obs;

  final bungaValue = 0.0.obs;
  final formattedBungaValue = '0'.obs;

  var tanggalPinjaman = ''.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? loanId;

  @override
  void onInit() {
    super.onInit();
    namaPinjamanC = TextEditingController();
    jumlahPinjamanC = TextEditingController();
    angsuranC = TextEditingController();
    bungaC = TextEditingController();
    loanId = Get.arguments as String?;
    if (loanId != null) {
      getLoanData();
    }

    updateFormattedJumlahPinjamanValue(jumlahPinjamanValue.value);
    updateFormattedAngsuranValue(angsuranValue.value);
    updateFormattedBungaValue(bungaValue.value);
  }

  void getLoanData() async {
    if (loanId != null) {
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('loans')
          .doc(loanId)
          .get();

      if (doc.exists) {
        var data = doc.data();
        if (data != null) {
          namaPinjamanC.text = data['namaPinjaman'] ?? '';
          jumlahPinjamanValue.value = data['jumlahPinjaman'] ?? 0;
          angsuranValue.value = data['angsuran'] ?? 0;
          bungaValue.value = data['bunga'] ?? 0;
          tanggalPinjaman.value = data['tanggalPinjaman'] ?? '';

          updateFormattedJumlahPinjamanValue(jumlahPinjamanValue.value);
          updateFormattedAngsuranValue(angsuranValue.value);
          updateFormattedBungaValue(bungaValue.value);
        }
      }
    }
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      tanggalPinjaman.value = DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  void updateJumlahPinjamanFromTextField(String value) {
    _updateValueFromTextField(value, jumlahPinjamanValue, updateFormattedJumlahPinjamanValue, max: 100000000);
  }

  void updateAngsuranFromSlider(double value) {
    angsuranValue.value = value.toInt();
    updateFormattedAngsuranValue(value.toInt());
  }

  void updateAngsuranFromTextField(String value) {
    String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isNotEmpty) {
      int intValue = int.parse(numericValue);
      if (intValue >= 1 && intValue <= 360) {
        angsuranValue.value = intValue;
        updateFormattedAngsuranValue(intValue);
      }
    }
  }

  void updateBungaFromTextField(String value) {
    _updateValueFromTextField(value, bungaValue, updateFormattedBungaValue, max: 100);
  }

  void _updateValueFromTextField(String value, RxDouble rxValue, Function(double) updateFormatted, {double max = 100000000}) {
    String numericValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (numericValue.isNotEmpty) {
      double doubleValue = double.parse(numericValue);
      if (doubleValue >= 0 && doubleValue <= max) {
        rxValue.value = doubleValue;
        updateFormatted(doubleValue);
      }
    }
  }

  void updateFormattedJumlahPinjamanValue(double value) {
    formattedJumlahPinjamanValue.value = formatCurrency(value);
    jumlahPinjamanC.text = formattedJumlahPinjamanValue.value;
  }

  void updateFormattedAngsuranValue(int value) {
    formattedAngsuranValue.value = value.toString();
    angsuranC.text = formattedAngsuranValue.value;
  }

  void updateFormattedBungaValue(double value) {
    formattedBungaValue.value = value.toStringAsFixed(2);
    bungaC.text = formattedBungaValue.value;
  }

  String formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  Future<bool> updateLoanData() async {
    if (loanId != null) {
      if (namaPinjamanC.text.isEmpty ||
          jumlahPinjamanValue.value == 0 ||
          angsuranValue.value == 0 ||
          bungaValue.value == 0 ||
          tanggalPinjaman.value.isEmpty) {
        Get.snackbar('Error', 'All fields must be filled');
        return false;
      }

      try {
        await firestore.collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('loans')
            .doc(loanId)
            .update({
          'namaPinjaman': namaPinjamanC.text,
          'jumlahPinjaman': jumlahPinjamanValue.value,
          'angsuran': angsuranValue.value,
          'bunga': bungaValue.value,
          'tanggalPinjaman': tanggalPinjaman.value,
        });
        return true;
      } catch (e) {
        Get.snackbar('Error', 'Failed to update loan: $e');
        return false;
      }
    }
    return false;
  }

  @override
  void dispose() {
    namaPinjamanC.dispose();
    jumlahPinjamanC.dispose();
    angsuranC.dispose();
    bungaC.dispose();
    super.dispose();
  }
}
