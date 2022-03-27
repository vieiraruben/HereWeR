import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/firestoreData/firestoreConfig/firebase_options.dart';
import 'package:mapview/views/mapview.dart';
import 'package:flutter/services.dart';
import 'package:mapview/views/verify_email.dart';
import 'views/welcome_view.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';

void main() async {
  // final settingsController = SettingsController(SettingsService());
  // await settingsController.loadSettings();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hyde Park Fest',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const HomePage(),
        routes: {
          welcomeRoute: (context) => const Welcome(),
          loginRoute: (context) => const LoginView(),
          signupRoute: (context) => const SignUpView(),
          mapRoute: (context) => MapView(),
          newProfileRoute: (context) => const NewProfileView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
        }),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              log(user.toString());
              if (user?.isAnonymous ?? false || user == null) {
                return const Welcome();
              }
              if (user?.emailVerified ?? false) {
                return MapView();
              } else {
                return const Welcome();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
