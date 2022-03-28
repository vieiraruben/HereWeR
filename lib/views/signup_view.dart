import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/services/exceptions.dart';
import 'package:mapview/services/auth/auth_service.dart';
import 'package:mapview/services/firebase_storage.dart';
import 'package:mapview/utilities/error_dialog.dart';

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
  final _formKey = GlobalKey<FormState>();

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

  void nextButtonAction() async {
    final email = _email.text;
    final password = _password.text;
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService.firebase()
            .createUser(email: email, password: password);
        Navigator.of(context).pushNamed('/signup/newprofile/');
      } on WeakPasswordAuthException {
        showErrorDialog(context, "Weak Password",
            "This password is too easy to guess. Please try a stronger password.");
      } on EmailAlreadyInUseAuthException {
        showErrorDialog(context, "Sign Up Failed",
            "An account already exists for this email address. Please log in.");
      } on InvalidEmailAuthException {
        showErrorDialog(context, "Sign Up Failed",
            "The email address you entered is invalid. Please try again.");
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Started")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text("Step 1/3", textScaleFactor: 1.3),
                const Text("Enter details to create your account."),
                const SizedBox(height: 50),
                TextFormField(
                  autofocus: true,
                  controller: _email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _password,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (v) => nextButtonAction(),
                  onEditingComplete: () => TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Password")),
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
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
  final _formKey = GlobalKey<FormState>();
  File? profilePic;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    _username = TextEditingController();
    super.initState();
  }

  void nextButtonAction() async {
    final username = _username.text;
    if (_formKey.currentState!.validate()) {
      try {
        final taken = await FirebaseCloudStorage().isUsernameTaken(username);
        print(taken);
        if (taken) {
          await showErrorDialog(context, "Username Taken",
              "This username has been choosen. Please try a different username.");
        } else {
          await AuthService.firebase().updateUsername(username: username);
          Navigator.of(context).pushNamed(verifyEmailRoute);
        }
      } on GenericAuthException {
        await showErrorDialog(context, "Undefined Error",
            "Something bad happened. Please check your connectivity and try again.");
      } catch (e) {
        log(e.toString());
      }
    }
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text("Step 2/3", textScaleFactor: 1.3),
                const Text("Choose a username and profile picture."),
                const SizedBox(height: 50),
                GestureDetector(
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 75,
                            backgroundColor:
                                const Color.fromARGB(255, 192, 229, 228),
                            foregroundImage: profilePic != null
                                ? FileImage(profilePic!)
                                : Image.asset(
                                        'assets/images/defaultprofile.png')
                                    .image),
                        Positioned(
                          child: Image.asset("assets/images/profileborder.png"),
                          width: 150,
                        ),
                        Positioned(
                            top: 100,
                            bottom: 0,
                            left: 100,
                            width: 50,
                            child: Image.asset(
                              "assets/images/add.png",
                              color: const Color.fromARGB(255, 0, 165, 165),
                            )),
                      ],
                    ),
                    onTap: () => pickImage()),
                const SizedBox(height: 50),
                TextFormField(
                  autofocus: true,
                  controller: _username,
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (v) => nextButtonAction(),
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Please choose your username';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Username"),
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      log(e.code);
    }
  }
}
