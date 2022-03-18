import 'package:flutter/material.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';

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
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              autocorrect: false,
              enableSuggestions: false,
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

                final user = AuthService.firebase().currentUser;
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } catch (e) {
                // TODO: Display error dialog
                print(e);
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
              child: const Text('Already Registered? Login Here'))
        ],
      )),
    );
  }
}
