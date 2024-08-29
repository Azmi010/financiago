import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String orderId;
  final String userId;
  final int grossAmount;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final List<ItemDetail> itemDetails;
  final String paymentStatus;
  final String waktuPengiriman;
  final Timestamp createdAt;

  TransactionModel({
    required this.orderId,
    required this.userId,
    required this.grossAmount,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.itemDetails,
    this.paymentStatus = '',
    required this.waktuPengiriman,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      orderId: map['orderId'],
      userId: map['userId'],
      grossAmount: map['grossAmount'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      itemDetails: List<ItemDetail>.from(
        map['itemDetails']?.map((x) => ItemDetail.fromMap(x)),
      ),
      waktuPengiriman: map['waktuPengiriman'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'grossAmount': grossAmount,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'itemDetails': itemDetails.map((x) => x.toMap()).toList(),
      'paymentStatus': paymentStatus,
      'waktuPengiriman': waktuPengiriman,
      'createdAt': createdAt,
    };
  }
}

class ItemDetail {
  final String id;
  final int price;
  final int quantity;
  final String name;

  ItemDetail({
    required this.id,
    required this.price,
    required this.quantity,
    required this.name,
  });

  factory ItemDetail.fromMap(Map<String, dynamic> map) {
    return ItemDetail(
      id: map['id'],
      price: map['price'],
      quantity: map['quantity'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'name': name,
    };
  }
}
