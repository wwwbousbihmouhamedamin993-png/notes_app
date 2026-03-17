import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:notes_app/router/app_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('signUp'),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: ('enter your email'),
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'enter your password',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text;
              final password = passwordController.text;
              try {
                await ref.read(authProvider.notifier).signUp(email, password);
                if (!context.mounted) return;
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text('SignUp'),
          ),
          TextButton(
            onPressed: () {
              context.go(Routes.loginRoute);
            },
            child: const Text('already have an account ? SignIN !!'),
          ),
        ],
      ),
    );
  }
}
