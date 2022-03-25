import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
// }

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
    return Scaffold(appBar: AppBar(title: const Text("Get Started")),
    resizeToAvoidBottomInset: false,
      body: Center(

                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                          // const Image(
                          //   image: AssetImage('assets/images/hpf_logo.jpg'),
                          // ),
                          
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Enter your email address"),
                                ),
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: _password,
                            autofillHints: const [AutofillHints.newPassword],
                            decoration: const InputDecoration(border: OutlineInputBorder(),
                            hintText: "Create a password"),
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                try {
                                  final userCredential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == "weak-password") {
                                    print("Weak password");
                                  } else if (e.code == "email-already-in-use") {
                                    print("Email already in use");
                                  } else if (e.code == "invalid-email") {
                                    print("Invalid email");
                                  }
                                }
                              },
                              child: const Text("Register")),
                      ],
                    ),
                        )),
    );
  }
}
