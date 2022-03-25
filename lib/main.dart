import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapview/firestoreData/firestoreConfig/firebase_options.dart';
import 'package:mapview/firestoreData/markers_data.dart';
import 'package:mapview/views/mapview.dart';
import 'package:flutter/services.dart';
import 'views/welcome.dart';
import 'views/login_view.dart';
import 'views/signup.dart';
import 'models/marker.dart';

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
        debugShowCheckedModeBanner:false,
        title: 'Hyde Park Fest',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const HomePage(),
        routes: {
          '/login/': (context) => const LoginView(),
          '/signup/': (context) => const SignUpView(),
          '/mapview/':(context) => MapView(),
        }),
  );
}

class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;
                  if (true) {
                  // if (user?.isAnonymous ?? false) {
                    return const Welcome();
                  }
                  if (user?.emailVerified ?? false) {
                    return const LoginView();
                  } else {
                    return const VerifyEmailView();
                  }
                default:
                  return const Text("Loading...");
              }
            }));
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    print(FirebaseAuth.instance.currentUser);
    return Column(children: [
      Text("We will send you an email to " + email),
      const Text(
          "Click the link on your email to validate your address and start enjoying the app."),
      TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("Send verification email"))
    ]);
  }
}


