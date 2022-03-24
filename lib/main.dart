import 'package:flutter/material.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/views/home/base_view.dart';
import 'package:homepay/views/home/new_house_view.dart';
import 'package:homepay/views/login_view.dart';
import 'package:homepay/views/register_view.dart';
import 'package:homepay/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 22, 27, 39),
        elevation: 0,
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 22, 27, 39),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 22, 27, 39),
          unselectedItemColor: Colors.white),
    ),
    home: const RootPage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      homeRoute: (context) => const BaseView(),
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
                    return const BaseView();
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
