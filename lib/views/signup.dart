import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                label: Text("Email"),
              ),
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _password,
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Password"),
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

  @override
  void initState() {
    _imagePicker = ImagePicker();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
        _imagePicker = ImagePicker();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Started")),
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
            Image.asset('assets/images/map.png'),
            // PickedFile image = await imagePicker.pickImage(source: ImageSource.gallery);
            ElevatedButton(
                onPressed: () async {
                  await _imagePicker.pickImage(source: ImageSource.gallery);
                },
                child: const Text("p")),

            TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Username"),
              ),
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                onPressed: () async {
                  final username = _username.text;
                  try {
                    await FirebaseAuth.instance.currentUser
                        ?.updateDisplayName(username);
                    print(FirebaseAuth.instance.currentUser);
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
      )),
    );
  }
}
