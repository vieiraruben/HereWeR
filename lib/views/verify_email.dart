import 'dart:developer';
import 'dart:io';
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
      Navigator.of(context)
          .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
      Navigator.of(context).pushNamed(loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Started")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
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
                    AuthService.firebase().sendEmailVerification();
                  },
                  child: const Text("Resend Email")),
              const SizedBox(height: 50),
              const Text(
                "Click the link on the email to validate your address and start enjoying the app.",
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      AndroidIntent intent = const AndroidIntent(
                        action: 'android.intent.action.MAIN',
                        category: 'android.intent.category.APP_EMAIL',
                      );
                      intent.launch().catchError((e) {
                        log(e);
                      });
                    } else if (Platform.isIOS) {
                      launch("message://").catchError((e) {
                        log(e);
                      });
                    }
                  },
                  child: const Text("Open Mail")),
              
            ],
          ),
        ),
      ),
    );
  }
}
