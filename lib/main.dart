import 'package:flutter/material.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/views/home/home_view.dart';
import 'package:homepay/views/home/new_house_view.dart';
import 'package:homepay/views/login_view.dart';
import 'package:homepay/views/register_view.dart';
import 'package:homepay/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.teal,
    ),
    home: const RootPage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      homeRoute: (context) => const HomeView(),
      addNewHouseRoute: (context) => const NewHouseView(),
    },
  ));
}

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  if (user.isEmailVerified) {
                    return const HomeView();
                  } else {
                    return const VerifyEmailView();
                  }
                } else {
                  return const LoginView();
                }
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
