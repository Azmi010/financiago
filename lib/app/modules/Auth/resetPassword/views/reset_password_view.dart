import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/input_akun_widget.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    var tinggi = MediaQuery.of(context).size.height;
    var lebar = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.backgroundCard,
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: lebar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png'),
                ],
              ),
            ),
            const Positioned(top: 20, left: 20, child: ButtonBackLeading()),

          ],
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
          ),
          height: tinggi*0.7,
          width: lebar,
          child: SizedBox(
            width: lebar,
            height: tinggi / 2,
            child: Column(
              children: [
                 Container(
                  width: lebar,
                  margin: EdgeInsets.only(left:lebar *0.1, top: 20, bottom: 20, right:lebar *0.1),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lupa Kata Sandi? 🔒",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Masukkan email Anda untuk menerima tautan reset.",
                        style: Utils.subtitle,
                      ),
                    ],
                  ),
                ),
                InputAkunWidget(controller: controller.emailController, nama: "Alamat email", hintText: "Masukan alamat email", leadingIcon: Icons.email),
                const SizedBox(height: 20,),
                ButtonWidget(onPressed: () => (controller.resetPassword(context)), nama: "Kirim Email"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun?", style: TextStyle(fontWeight: FontWeight.w400, color: Utils.biruDua),),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.biruSatu)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
