import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/input_akun_widget.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  final List<String> roles = ['Pengguna', 'Konselor'];

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
              margin: const EdgeInsets.only(top: 30),
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
        bottomSheet: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            height: tinggi * 0.70,
            width: lebar,
            child: Column(
              children: [
                Container(
                  width: lebar,
                  margin: EdgeInsets.only(
                      left: lebar * 0.1, top: 20, right: lebar * 0.1,bottom: 20,),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang! 🙌",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Buat akun baru Anda dan mulai petualangan baru bersama kami.",
                        style: Utils.subtitle,
                      ),
                    ],
                  ),
                ),
                InputAkunWidget(
                    controller: controller.fullNameController,
                    nama: "Nama lengkap",
                    hintText: "Masukan nama lengkap",
                    leadingIcon: Icons.person),
                const SizedBox(height: 10),
                InputAkunWidget(
                  controller: controller.emailController,
                  hintText: "Masukan email",
                  leadingIcon: Icons.email,
                  nama: "Alamat email",
                ),
                const SizedBox(height: 10),
                InputAkunWidget(
                  controller: controller.passwordController,
                  nama: "Kata sandi",
                  hintText: "Masukan kata sandi",
                  leadingIcon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                ButtonWidget(
                    onPressed: () => controller.signup(context),
                    nama: "Daftar"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya akun?",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Utils.biruDua),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Masuk",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils.biruSatu)),
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