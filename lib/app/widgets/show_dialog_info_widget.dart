import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';

void showDialogInfoWidget(judul, icon, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Utils.backgroundCard),
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                judul,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'assets/images/$icon.png',
                scale: 3,
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                  onPressed: () {
                    Get.back();
                  },
                  nama: 'Oke 👌')
            ],
          ),
        ),
      );
    },
  );
}
