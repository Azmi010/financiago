import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeloan/app/modules/Auth/splash.dart';
import 'package:safeloan/app/services/notification_manager.dart';
import 'package:safeloan/firebase_options.dart';
import 'package:safeloan/app/widgets/loading.dart';
import 'app/modules/Auth/login/controllers/login_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.notification.request();
  await NotificationService().initNotification();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(LoginController(), permanent: true);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null && snapshot.data!.emailVerified) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.data != null && userSnapshot.data!.exists) {
                    String role = userSnapshot.data!['role'];
                    String nextRoute;
                    if (role == 'Pengguna') {
                      nextRoute = Routes.NAVIGATION;
                      NotificationManager().scheduleNotifications(snapshot.data!.uid);  // Gunakan NotificationManager
                    } else if (role == 'Konselor') {
                      nextRoute = Routes.NAVIGATION_KONSELOR;
                    } else if (role == 'Admin') {
                      nextRoute = Routes.NAVIGATION_ADMIN;
                    } else {
                      nextRoute = Routes.LOGIN;
                    }
                    return GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                          textTheme: GoogleFonts.montserratTextTheme(
                              Theme.of(context).textTheme), appBarTheme: const AppBarTheme(
                            backgroundColor: Colors.white,
                          ),
                          scaffoldBackgroundColor: Colors.white,),
                      title: "Application",
                      home: SplashView(nextRoute: nextRoute),
                      getPages: AppPages.routes,
                    );
                  }
                }
                return const LoadingView();
              },
            );
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textTheme: GoogleFonts.montserratTextTheme(
                      Theme.of(context).textTheme),
                      appBarTheme: const AppBarTheme(
                            backgroundColor: Colors.white,
                          ),
                          scaffoldBackgroundColor: Colors.white,),
              title: "Application",
              home: const SplashView(nextRoute: Routes.LOGIN),
              getPages: AppPages.routes,
            );
          }
        } else {
          return const LoadingView();
        }
      },
    );
  }
}
