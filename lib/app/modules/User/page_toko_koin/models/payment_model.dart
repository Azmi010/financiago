

import 'package:safeloan/app/modules/User/page_toko_koin/models/transaction_model.dart';

class PaymentModel{
  final Map<String, dynamic> transactionDetails;
  final Map<String, dynamic> customerDetails;
  final List<Map<String, dynamic>> itemDetails;
  final Map<String, dynamic> shippingDetails;

  PaymentModel({
    required this.transactionDetails,
    required this.customerDetails,
    required this.itemDetails,
    required this.shippingDetails
  });

  factory PaymentModel.fromCheckoutModel(TransactionModel checkout){
    return PaymentModel(
      transactionDetails: {
        'order_id': checkout.orderId,
        'gross_amount': checkout.grossAmount,
      },
      customerDetails: {
        'first_name': checkout.firstName,
        'last_name': checkout.lastName,
        'email': checkout.email,
        'phone': checkout.phone,
      },
      itemDetails: checkout.itemDetails.map((item) => item.toMap()).toList(),
      shippingDetails: {
        'delivery_time' : checkout.waktuPengiriman,
        'delivery_address' : checkout.address, 
      }
    );
  }

  toMap(){
    return {
      'transaction_details': transactionDetails,
      'customer_details': customerDetails,
      'item_details': itemDetails,
      'shipping_details' : shippingDetails
    };
  }
}

