import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/services/notification_manager.dart';

import '../../../../widgets/show_dialog_info_widget.dart';

class AddLoanController extends GetxController {
  late TextEditingController namaPinjamanC;
  late TextEditingController jumlahPinjamanC;
  late TextEditingController angsuranC;
  late TextEditingController bungaC;
  final NotificationManager notificationManager = NotificationManager();

  final jumlahPinjamanValue = 0.0.obs;
  final formattedJumlahPinjamanValue = '0'.obs;

  final angsuranValue = 1.obs;
  final formattedAngsuranValue = '1'.obs;

  final bungaValue = 0.0.obs;
  final formattedBungaValue = '0'.obs;

  var tanggalPinjaman = Rxn<DateTime>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    namaPinjamanC = TextEditingController();
    jumlahPinjamanC = TextEditingController();
    angsuranC = TextEditingController();
    bungaC = TextEditingController();

    updateFormattedJumlahPinjamanValue(jumlahPinjamanValue.value);
    updateFormattedAngsuranValue(angsuranValue.value);
    updateFormattedBungaValue(bungaValue.value);
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: tanggalPinjaman.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      tanggalPinjaman.value = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );
    }
  }

  void updateJumlahPinjamanFromSlider(double value) {
    if (value >= 0 && value <= 100000000) {
      jumlahPinjamanValue.value = value;
      updateFormattedJumlahPinjamanValue(value);
    }
  }

  void updateJumlahPinjamanFromTextField(String value) {
    _updateValueFromTextField(
        value, jumlahPinjamanValue, updateFormattedJumlahPinjamanValue,
        max: 100000000);
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
    _updateValueFromTextField(value, bungaValue, updateFormattedBungaValue,
        max: 100);
  }

  void _updateValueFromTextField(
      String value, RxDouble rxValue, Function(double) updateFormatted,
      {double max = 100000000}) {
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

  Future<bool> addLoan(BuildContext context) async {
    if (namaPinjamanC.text.isEmpty ||
        jumlahPinjamanValue.value == 0 ||
        angsuranValue.value == 0 ||
        bungaValue.value == 0 ||
        tanggalPinjaman.value == null) {
      return false;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final loanData = {
        'namaPinjaman': namaPinjamanC.text,
        'jumlahPinjaman': jumlahPinjamanValue.value,
        'angsuran': angsuranValue.value,
        'bunga': bungaValue.value,
        'tanggalPinjaman': Timestamp.fromDate(DateTime(
          tanggalPinjaman.value!.year,
          tanggalPinjaman.value!.month,
          tanggalPinjaman.value!.day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
        )),
        'createdAt': DateTime.now(),
      };

      await firestore
          .collection('users')
          .doc(userId)
          .collection('loans')
          .add(loanData);

      final notificationManager = NotificationManager();
      await notificationManager.scheduleNotifications(userId);

      Get.back();
      showDialogInfoWidget("Berhasil menambahkan pinjaman", 'succes', context);

      return true;
    } catch (e) {
      return false;
    }
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
