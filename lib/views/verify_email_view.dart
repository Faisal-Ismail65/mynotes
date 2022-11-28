// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an Email Verification. Please Open it and Verify Your Account"),
          const Text(
              "If You haven't recieved a verification email yet, Press the Button Below "),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send Verification Email'),
          ),
          TextButton(
            onPressed: (() async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            }),
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
