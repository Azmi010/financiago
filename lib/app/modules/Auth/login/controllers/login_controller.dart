import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:safeloan/app/routes/app_pages.dart';
import 'package:safeloan/app/widgets/confirm_show_dialog_widget.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get streamAuthStatus => _auth.authStateChanges();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!_isValidCredentials(email, password)) {
      showDialogInfoWidget("Email dan Password tidak boleh kosong.", 'fail', context);
      return;
    }

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        showDialogInfoWidget("Gagal login! Coba lagi.", 'fail', context);
        return;
      }

      if (!user.emailVerified) {
        await _handleUnverifiedEmail(context, user);
        return;
      }

      await _handleVerifiedUser(context, user);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(context, e);
    } catch (e) {
      showDialogInfoWidget("Gagal login! Coba lagi.", 'fail', context);
    }
  }

  bool _isValidCredentials(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }

  Future<void> _handleUnverifiedEmail(BuildContext context, User user) async {
    confirmShowDialog(
      judul: "Kamu perlu verifikasi email terlebih dahulu. Apakah kamu ingin dikirimkan verifikasi ulang?",
      onPressed: () async {
        await user.sendEmailVerification();
        Get.back();
      },
      context: context,
      textBatal: "Tidak",
      textSetuju: "Kirim",
    );
  }

  Future<void> _handleVerifiedUser(BuildContext context, User user) async {
    final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
    
    if (!userDoc.exists) {
      showDialogInfoWidget("Data user tidak ditemukan.", 'fail', context);
      return;
    }

    final String? role = userDoc.get('role') as String?;
    if (role == null) {
      showDialogInfoWidget("Terjadi Kesalahan.", 'fail', context);
      return;
    }

    showDialogInfoWidget("Anda berhasil login.", 'success', context);
    _navigateBasedOnRole(role);
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'Pengguna':
        Get.offAllNamed(Routes.NAVIGATION, arguments: {'initialIndex': 0});
        break;
      case 'Konselor':
        Get.offAllNamed(Routes.NAVIGATION_KONSELOR, arguments: {'initialIndex': 0});
        break;
      case 'Admin':
        Get.offAllNamed(Routes.NAVIGATION_ADMIN, arguments: {'initialIndex': 0});
        break;
      default:
        Get.snackbar('Error', 'Role tidak dikenali');
    }
  }

  void _handleFirebaseAuthError(BuildContext context, FirebaseAuthException e) {
    if (kDebugMode) {
      print('Firebase Auth Error: ${e.code}');
    }

    switch (e.code) {
      case 'user-not-found':
        showDialogInfoWidget("User tidak ditemukan.", 'fail', context);
        break;
      case 'wrong-password':
        showDialogInfoWidget("Email dan Password salah, cek kembali data anda!", 'fail', context);
        break;
      default:
        showDialogInfoWidget("Email atau Kata Sandi Anda Salah", 'fail', context);
    }
  }
}