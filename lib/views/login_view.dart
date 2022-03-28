import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/services/exceptions.dart';
import 'package:mapview/services/auth_service.dart';
import 'package:mapview/utilities/error_dialog.dart';

// TODO: Add forgotten password option

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

  void loginButton() async {
    if (_formKey.currentState!.validate()) {
      final email = _email.text;
      final password = _password.text;
      try {
        await AuthService.firebase().logIn(email: email, password: password);
        final user = AuthService.firebase().currentUser;
        if (user?.isEmailVerified ?? false) {
          Navigator.of(context).pushNamed(mapRoute);
        } else {
          Navigator.of(context).pushNamed(verifyEmailRoute);
        }
      } on UserNotFoundAuthException {
        await showErrorDialog(context, "Login Failed",
              "We can't find an account with this email address. Please try again.");
      } on WrongPasswordAuthException {
        await showErrorDialog(context, "Incorrect Password",
              "The password you entered is incorrect. Please try again.");
      } on GenericAuthException {
        await showErrorDialog(context, "Undefined Error",
              "Something bad happened. Please check your connectivity and try again.");
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(AuthService.firebase().currentUser.toString());
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 75,
                        backgroundColor:
                            const Color.fromARGB(255, 192, 229, 228),
                        foregroundImage:
                            Image.asset('assets/images/defaultprofile.png')
                                .image),
                    Positioned(
                      child: Image.asset("assets/images/profileborder.png"),
                      width: 150,
                    ),
                  ],
                ),
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
                  onFieldSubmitted: (v) => loginButton(),
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Password")),
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
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
