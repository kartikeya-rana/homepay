import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_exception.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards_storage.dart';
import 'package:homepay/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isButtonEnabled = true;

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
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'lib/assets/images/homepay_logo.png',
              fit: BoxFit.fitHeight,
            ),
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
          // const SizedBox(height: 2),
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
            onPressed: _isButtonEnabled
                ? () async {
                    setState(() {
                      _isButtonEnabled = false;
                    });
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      await AuthService.firebase()
                          .logIn(email: email, password: password);

                      final user = AuthService.firebase().currentUser;

                      if (user != null) {
                        if (user.isEmailVerified) {
                          final CloudRewardsStorage _rewardService =
                              CloudRewardsStorage();
                          final rewardNotAvailable = await _rewardService
                              .isRewardProfile(userId: user.id);

                          if (rewardNotAvailable) {
                            await _rewardService.createNewUserRewards(
                                userId: user.id);
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute, (route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute, (route) => false);
                        }
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        "User not found",
                      );
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Wrong password",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Authentication Error",
                      );
                    }
                  }
                : null,
            child: const Text('Login'),
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 2),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('New User? Sign Up')),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
