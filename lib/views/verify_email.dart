import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/services/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    AuthService.firebase().sendEmailVerification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: Check email verifed and log in here;
    if (state == AppLifecycleState.resumed) {
      print(AuthService.firebase().currentUser?.isEmailVerified);
      if (AuthService.firebase().currentUser!.isEmailVerified) {
        Navigator.of(context).pushNamed(mapRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Get Started"),
              actions: [
                PopupMenuButton<String>(
                    onSelected: (v) {
                      Navigator.of(context).pushNamed(welcomeRoute);
                    },
                    itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                              value: "Start Over", child: Text("Start Over"))
                        ])
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text("Step 3/3", textScaleFactor: 1.3),
                  const Text("Verify your email address."),
                  const SizedBox(height: 50),
                  const Text("A confirmation has been sent to:"),
                  Text(AuthService.firebase().currentUser?.email ?? "undefined",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(loginRoute);
                      },
                      child: const Text("Log In")),
                  const SizedBox(height: 50),
                  const Text(
                    "Click the link on the email to validate your address and start enjoying the app.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  TextButton(
                      onPressed: () {
                        AuthService.firebase().sendEmailVerification();
                      },
                      child: const Text("Resend Email")),
                  
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(mapRoute);
                      },
                      child: const Text(""))
                ],
              ),
            ),
          ),
        ));
  }
}
