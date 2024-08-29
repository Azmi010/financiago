import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/editLoan/controllers/edit_loan_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class EditLoanView extends GetView<EditLoanController> {
  const EditLoanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text(
          'Tambah Data Pinjaman',
          style: Utils.header,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller.namaPinjamanC,
                decoration: const InputDecoration(
                  labelText: 'Nama Pinjaman',
                  hintText: 'Masukkan Nama Pinjaman',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextFieldNoSlider(
                'Jumlah Pinjaman',
                'Masukkan jumlah pinjaman',
                controller.formattedJumlahPinjamanValue,
                controller.jumlahPinjamanValue,
                (value) => controller.updateJumlahPinjamanFromTextField(value),
                null,
                Icons.monetization_on,
                Colors.green,
                prefix: 'Rp ',
              ),
              const SizedBox(height: 20),
              _buildTextFieldTenor(
                'Jumlah Angsuran',
                'Masukkan jumlah angsuran',
                controller.formattedAngsuranValue,
                controller.angsuranValue,
                (value) => controller.updateAngsuranFromTextField(value),
                (value) => controller.updateAngsuranFromSlider(value),
                Icons.calendar_today,
                Colors.blue,
              ),
              const SizedBox(height: 20),
              _buildTextFieldNoSlider(
                'Bunga',
                'Masukkan bunga',
                controller.formattedBungaValue,
                controller.bungaValue,
                (value) => controller.updateBungaFromTextField(value),
                null, // Tidak ada slider untuk bunga
                Icons.percent,
                Colors.orange,
                suffix: '%',
                min: 0,
                max: 25,
              ),
              const SizedBox(height: 20),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Tanggal Pinjaman: ${controller.tanggalPinjaman.value}'),
                      InkWell(
                        onTap: () => controller.pickDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Text('Pilih Tanggal'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 30),
              ButtonWidget(
                onPressed: () async {
                  try {
                    bool success = await controller.updateLoanData();
                    if (success) {
                      Get.back();
                      showDialogInfoWidget(
                          "Berhasil mengupdate pinjaman", 'succes', context);

                    } else {
                      showDialogInfoWidget(
                          "Gagal mengupdate pinjaman", 'fail', context);
                    }
                  } catch (e) {
                    print('Error saat menambahkan pinjaman: $e');
                    showDialogInfoWidget(
                        "Terjadi masalah saat mengupdate pinjaman", 'fail', context);
                  }
                },
                nama: 'Update',
              ),
            ],
          ),
        ),
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
}
