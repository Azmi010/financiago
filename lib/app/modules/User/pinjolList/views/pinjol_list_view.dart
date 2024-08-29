import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import '../controllers/pinjol_list_controller.dart';

class PinjolListView extends GetView<PinjolListController> {
  const PinjolListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinjol Legal', style: 
        Utils.header),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Data berikut merupakan daftar Pinjaman Online legal yang sudah terdaftar di Otoritas Jasa Keuangan.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Pinjol...',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
              ),
              onChanged: controller.updateSearchTerm,
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value && controller.filteredPinjols.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredPinjols.isEmpty && !controller.isLoading.value) {
                  return const Center(child: Text('Tidak ada pinjol ditemukan'));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!controller.isLoading.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: controller.filteredPinjols.length + (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.filteredPinjols.length) {
                        // Show a loading indicator when more data is being fetched
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final pinjol = controller.filteredPinjols[index];
                      return Card(
                        color: Utils.backgroundCard,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Icon(Icons.money_off, color: Colors.blue[700]),
                          title: Text(
                            pinjol['namaAplikasi'] ?? 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            pinjol['namaPerusahaan'] ?? 'N/A',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[700]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
