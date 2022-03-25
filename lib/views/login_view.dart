import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
        children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(border: OutlineInputBorder(),
                              hintText:"Enter your email address"),
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _password,
              decoration: const InputDecoration(border: OutlineInputBorder(),
                              hintText: "Enter your password"),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
            ),
            ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    print(userCredential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print(e.code);
                    } else if (e.code == "wrong-password") {
                      print("Wrong password");
                    } else {
                      print(e.code);
                    }
                  }
                },
                child: const Text("Log In")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/signup/',
                  );
                },
                child: const Text("Sign Up")),
            const Text("Powered by HereWeR")
        ],
      ),
          )),
    );
  }
}
