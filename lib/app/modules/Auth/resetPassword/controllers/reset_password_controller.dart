import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Auth/login/views/login_view.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class ResetPasswordController extends GetxController {
  final emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (!_isValidEmail(email)) {
      showDialogInfoWidget("Email tidak valid.", "fail", context);
      return;
    }

    try {
      await _sendPasswordResetEmail(email, context);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e, context);
    } catch (e) {
      showDialogInfoWidget("Terjadi kesalahan, coba lagi.", "fail", context);
    }
  }

  bool _isValidEmail(String email) {
    return email.isNotEmpty && GetUtils.isEmail(email);
  }

 Future<void> _sendPasswordResetEmail(String email, BuildContext context) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    Get.offAll(() => const LoginView());
    showDialogInfoWidget(
      "Kami telah mengirimkan Reset Password ke email $email.",
      "succes",
      context
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showDialogInfoWidget("Email tidak terdaftar.", "fail", context);
    } else {
      _handleFirebaseAuthError(e, context);
    }
  } catch (e) {
    showDialogInfoWidget("Terjadi kesalahan, coba lagi.", "fail", context);
  }
}


  void _handleFirebaseAuthError(FirebaseAuthException e, BuildContext context) {
    if (kDebugMode) {
      print('FirebaseAuthException: ${e.code}');
    }

    switch (e.code) {
      case 'user-not-found':
        showDialogInfoWidget("Email tidak terdaftar.", "fail", context);
        break;
      default:
        showDialogInfoWidget("Tidak dapat melakukan Reset Password.", "fail", context);
    }
  }
}