import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/models/transaction_model.dart';
import 'package:safeloan/app/services/transaction_service.dart';

class PageTokoKoinController extends GetxController {
  MidtransSDK? _midtrans;
  TransactionService transactionService = TransactionService();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    initSDK();
    super.onInit();
  }

  void initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: dotenv.env['MIDTRANS_CLIENT_KEY'] ?? "",
        merchantBaseUrl: dotenv.env['MIDTRANS_MERCHANT_BASE_URL'] ?? "",
        colorTheme: ColorTheme(
          colorPrimary: const Color.fromARGB(255, 45, 130, 181),
        ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) async {
      print(result.toJson());
      if (result.transactionStatus == 'settlement') {
        await _updateUserCoins();
      }
    });
  }

  Future<void> startPayment(ItemDetail item) async {
    final transactionData = TransactionModel(
      orderId: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
      userId: _firebaseAuth.currentUser!.uid,
      grossAmount: item.price,
      firstName: 'kelolain',
      lastName: 'user',
      email: 'devakses@gmail.com',
      phone: '08951518792',
      address: 'jember',
      itemDetails: [item],
      waktuPengiriman: 'PAGI',
      createdAt: Timestamp.now(),
    );
    final response =
        await transactionService.createTransaction(transactionData);
    if (response['snap_token'] == null) {
      print("Snap token is null");
      return;
    }
    print("Snap token received: ${response['snap_token']}");
    await _midtrans!.startPaymentUiFlow(token: response['snap_token']);
    _updateUserCoins();
  }

  Future<void> _updateUserCoins() async {
    String userId = _firebaseAuth.currentUser!.uid;
    DocumentReference userRef = _firestore.collection('users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw Exception("User does not exist!");
      }

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      int currentCoins = userData['coin'] ?? 0;
      int newCoins = currentCoins + 55;

      transaction.update(userRef, {'coin': newCoins});
    });
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }
}
