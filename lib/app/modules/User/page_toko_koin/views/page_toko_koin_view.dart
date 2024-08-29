import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/models/transaction_model.dart';
import 'package:safeloan/app/modules/User/profile/controllers/profile_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';

import '../controllers/page_toko_koin_controller.dart';

class PageTokoKoinView extends GetView<PageTokoKoinController> {
  const PageTokoKoinView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final ProfileController coinController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Toko Koin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(()=> koin('assets/images/koin.png', '${coinController.userData['coin'] ?? 0}')),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                _cardItem("25 Coin", 'assets/images/25koin.png', 'Rp25.000', 25000),
                _cardItem("55 Coin", 'assets/images/55koin.png', 'Rp50.000', 50000),
                _cardItem("80 Coin", 'assets/images/80koin.png', 'Rp75.000', 75000),
                _cardItem("120 Coin", 'assets/images/120koin.png', 'Rp100.000', 100000),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget koin(String icon, String koin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      margin: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Utils.backgroundCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Poin Kamu :  $koin',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 5),
          Image.asset(icon),
        ],
      ),
    );
  }

  Widget _cardItem(String jumlahCoin, String linkImage, String hargaCoin, int price) {
    PageTokoKoinController controller = Get.put(PageTokoKoinController());
    return Card(
      elevation: 4,
      color: Utils.biruLima,
      child: InkWell(
        onTap: () async {
          final item = ItemDetail(
            id: price.toString(),
            price: price,
            quantity: 1,
            name: jumlahCoin,
          );
          await controller.startPayment(item);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                jumlahCoin,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Image.asset(
                linkImage,
                scale: 0.5,
                width: 125,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Utils.biruSatu,
                ),
                child: Text(
                  hargaCoin,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
