import 'package:flutter/material.dart';
import 'package:safeloan/app/utils/warna.dart';

Widget inputAdminWidget(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Utils.backgroundCard),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Utils.biruDua),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }