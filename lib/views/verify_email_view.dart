import 'package:flutter/material.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          const Icon(
            Icons.mail_rounded,
            size: 50,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'An email has been sent to your provided email address. Kindly verify the email and sign in again.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text(
              'Resend Email Verification',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
