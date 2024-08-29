import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/confirm_show_dialog_widget.dart';
import '../controllers/detail_finance_controller.dart';

class DetailFinanceView extends GetView<DetailFinanceController> {
  const DetailFinanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DetailFinanceController controller =
        Get.put(DetailFinanceController());
    var lebar = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Keuangan',
          style: Utils.header,
        ),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: Obx(
        () {
          final financeData = controller.financeData;

          if (financeData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final titleController =
              TextEditingController(text: financeData['title']);
          final jumlahController = TextEditingController(
              text: financeData['nominal']?.toStringAsFixed(0));
          final deskripsiController =
              TextEditingController(text: financeData['notes']);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildEditableCard(
                  title: 'Judul',
                  icon: FontAwesomeIcons.heading,
                  controller: titleController,
                ),
                _buildEditableCard(
                  title: 'Jumlah',
                  icon: FontAwesomeIcons.moneyBillWave,
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                ),
                _buildNonEditableCard(
                  title: 'Tanggal',
                  icon: FontAwesomeIcons.calendarDays,
                  content: financeData['date'] != null
                      ? DateFormat('dd MMMM yyyy').format(financeData['date'])
                      : 'N/A',
                ),
                _buildNonEditableCard(
                  title: 'Kategori',
                  icon: FontAwesomeIcons.tag,
                  content: financeData['category'],
                ),
                _buildEditableCard(
                  title: 'Deskripsi',
                  icon: FontAwesomeIcons.circleInfo,
                  controller: deskripsiController,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: lebar,
                      child: ButtonWidget(
                        colorBackground: Colors.white,
                        colorText: Utils.biruSatu,
                        onPressed: () {
                          _showDeleteConfirmationDialog(controller, context);
                        },
                        nama: 'Hapus',
                      ),
                    ),
                    SizedBox(
                      width: lebar,
                      child: ButtonWidget(
                        onPressed: () {
                          _updateFinance(controller, titleController,
                              jumlahController, deskripsiController, context);
                        },
                        nama: 'Simpan',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableCard({
    required String title,
    required IconData icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Card(
      color: Utils.backgroundCard,
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(border: UnderlineInputBorder()),
        ),
      ),
    );
  }

  Widget _buildNonEditableCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Card(
      color: Utils.backgroundCard,
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }

  void _updateFinance(
      DetailFinanceController controller,
      TextEditingController titleController,
      TextEditingController jumlahController,
      TextEditingController deskripsiController,
      BuildContext context) {
    final jumlah = jumlahController.text;
    final nominal = double.tryParse(jumlah);

    final financeId = Get.arguments['docId'] as String?;
    final type = Get.arguments['type'] as String?;

    if (financeId == null || type == null) {
      Get.snackbar('Error', 'Invalid arguments for updating finance data.');
      return;
    }

    controller.updateFinanceData(
        financeId,
        type,
        {
          'title': titleController.text,
          'nominal': nominal,
          'notes': deskripsiController.text,
        },
        context);
  }

  void _showDeleteConfirmationDialog(
      DetailFinanceController controller, BuildContext context) {
    final financeId = Get.arguments['docId'] as String?;
    final type = Get.arguments['type'] as String?;

    // Debug logging
    print('Delete Confirmation: docId = $financeId, type = $type');

    if (financeId == null || type == null) {
      Get.snackbar('Error', 'Invalid arguments for deleting finance data.');
      return;
    }
    confirmShowDialog(
        judul: 'Apakah Anda yakin ingin menghapus data ini?',
        onPressed: () {
          Get.back();
          Get.back();
          controller.deleteFinanceData(financeId, type, context);
        },
        context: context);
  }
}
