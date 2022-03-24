import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_exception.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(14),
            child: TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(color: loginFormlabelColor),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: loginFormBorderColor)),
              ),
              style: const TextStyle(color: loginFormInputColor),
              autocorrect: false,
              enableSuggestions: true,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.all(14),
            child: TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: loginFormlabelColor),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: loginFormBorderColor)),
              ),
              style: const TextStyle(color: loginFormInputColor),
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
              obscuringCharacter: '*',
            ),
          ),
          const SizedBox(height: 2),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().createuser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, (route) => false);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Weak password");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email already in use");
              } on InvalidEmailException {
                await showErrorDialog(context, "Invalid email");
              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
              }
            },
            child: const Text('Register'),
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 2),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already Registered? Sign In'))
        ],
      )),
    );
  }
}
