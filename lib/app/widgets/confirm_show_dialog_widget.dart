import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';

void confirmShowDialog(
    {required String judul,required VoidCallback onPressed,required BuildContext context, String textBatal = "Tidak", String textSetuju = "Yakin"}) {
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Image.asset(
                "assets/images/confirm.png",
                scale: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    child: ButtonWidget(
                        colorBackground: Utils.biruLima,
                        colorText: Utils.biruSatu,
                        onPressed: () {
                          Get.back();
                        },
                        nama: textBatal),
                  ),
                  SizedBox(
                      width: 100,
                      child: ButtonWidget(onPressed: onPressed, nama: textSetuju))
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
