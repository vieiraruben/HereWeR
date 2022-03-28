import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/services/auth_service.dart';
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hyde Park Fest',
        theme: ThemeData(primarySwatch: Colors.indigo),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null && user.isEmailVerified) {
                return MapView();
              } else {
                return const Welcome();
              }
            default:
              return const CircularProgressIndicator();
          }
        }
    );
  }
}
