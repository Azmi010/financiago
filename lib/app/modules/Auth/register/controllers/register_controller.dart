import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Auth/login/views/login_view.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final roleController = TextEditingController(text: "Pengguna");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    roleController.dispose();
    super.onClose();
  }

  Future<void> signup(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final fullName = fullNameController.text.trim();
    final role = roleController.text.trim();

    if (!_isValidInput(email, password, fullName, role)) {
      showDialogInfoWidget('Semua field harus diisi', 'fail', context);
      return;
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _createUserDocument(userCredential.user!.uid, fullName, email, role);
      await _sendVerificationEmail(userCredential.user!);

      Get.offAll(() => const LoginView());
      showDialogInfoWidget('Berhasil daftar, cek email kamu!', 'succes', context);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e, context);
    } catch (e) {
      debugPrint("Error: $e");
      showDialogInfoWidget('Gagal mendaftar dengan akun ini', 'fail', context);
    }
  }

  bool _isValidInput(String email, String password, String fullName, String role) {
    return email.isNotEmpty && password.isNotEmpty && fullName.isNotEmpty && role.isNotEmpty;
  }

  Future<void> _createUserDocument(String uid, String fullName, String email, String role) async {
    await _firestore.collection('users').doc(uid).set({
      'fullName': fullName,
      'email': email,
      'role': role,
    });
  }

  Future<void> _sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  void _handleFirebaseAuthError(FirebaseAuthException e, BuildContext context) {
    switch (e.code) {
      case 'weak-password':
        showDialogInfoWidget('Password Terlalu Lemah', 'fail', context);
        break;
      case 'email-already-in-use':
        showDialogInfoWidget('Alamat Email Sudah Digunakan', 'fail', context);
        break;
      default:
        showDialogInfoWidget('Terjadi kesalahan saat mendaftar', 'fail', context);
    }
  }
}