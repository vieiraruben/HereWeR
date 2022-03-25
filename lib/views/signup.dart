import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Get Started")),
      resizeToAvoidBottomInset: true,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Step 1/3", textScaleFactor: 1.3),
                      Text("Enter details to create an account.")
                    ])),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Email"),
                    ),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _password,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text("Password")),
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                // final userCredential = await FirebaseAuth.instance
                                //     .createUserWithEmailAndPassword(
                                //         email: email, password: password);
                                Navigator.of(context).pushNamed(
                                  '/newprofile/',
                                );
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
                            child: const Text("Next")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class NewProfileView extends StatefulWidget {
  const NewProfileView({Key? key}) : super(key: key);

  @override
  State<NewProfileView> createState() => _NewProfileViewState();
}

class _NewProfileViewState extends State<NewProfileView> {
  late final TextEditingController _username;
  late final ImagePicker _imagePicker;
  File? profilePic;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Get Started")),
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Step 2/3", textScaleFactor: 1.3),
                          Text("Choose a username and profile picture.")
                        ])),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          child: Stack(children: [
                            CircleAvatar(radius: 75, backgroundColor: Colors.amber.withAlpha(0),
                              foregroundImage:
                              profilePic != null ? FileImage(profilePic!) : Image.asset('assets/images/defaultprofile.png').image),
                              Positioned(child: Image.asset("assets/images/profileborder.png"), width: 150,),
                              Positioned(top:100, bottom: 0, left: 100, width: 50,
                                child: Image.asset("assets/images/add.png", color:
                                const Color.fromARGB(255, 0, 165, 165),)),
                          ],
                          
                          ),
                          onTap: () => pickImage()),
                          const SizedBox(height: 20),
                      TextFormField(
                        controller: _username,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Username"),
                        ),
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () async {
                                  final username = _username.text;
                                  try {
                                    // await FirebaseAuth.instance.currentUser
                                    //     ?.updateDisplayName(username);
                                    Navigator.of(context).pushNamed(
                                      '/mapview/',
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == "weak-password") {
                                      print("Weak password");
                                    } else if (e.code ==
                                        "email-already-in-use") {
                                      print("Email already in use");
                                    } else if (e.code == "invalid-email") {
                                      print("Invalid email");
                                    }
                                  }
                                },
                                child: const Text("Next")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future pickImage() async {
    try {
      final profilePic =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (profilePic == null) {
        return;
      }
      final profilePicPath = File(profilePic.path);
      this.profilePic = profilePicPath;
      setState(() => this.profilePic = profilePicPath);
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
