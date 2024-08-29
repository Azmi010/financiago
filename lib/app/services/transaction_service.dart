import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/models/payment_model.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/models/transaction_model.dart';
import 'midtrans_service.dart';

class TransactionService extends GetxService {
  final MidtransService _midtransService = Get.put(MidtransService());

  Future<Map<String, dynamic>> createTransaction(TransactionModel checkout) async {
    final transactionData = PaymentModel.fromCheckoutModel(checkout);
    return await _midtransService.createSnapToken(transactionData);
  }
}