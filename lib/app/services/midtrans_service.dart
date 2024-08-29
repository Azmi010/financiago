import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/page_toko_koin/models/payment_model.dart';

class MidtransService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://kelola-midtrans.vercel.app/',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  Future<Map<String, dynamic>> createSnapToken(
      PaymentModel transactionData) async {
    try {
      print("Sending data to Midtrans:");
      print(JsonEncoder.withIndent('  ').convert(transactionData.toMap()));
      final response =
          await _dio.post('/create-snap', data: transactionData.toMap());
      print('Snap Token: ${response.data['snap_token']}');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
}
