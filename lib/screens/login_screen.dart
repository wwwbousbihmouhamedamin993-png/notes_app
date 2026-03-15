import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:notes_app/router/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                await ref.read(authProvier.notifier).signIn(email, password);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text('SignIn'),
          ),
          TextButton(
            onPressed: () {
              context.go(Routes.signUpRoute);
            },
            child: const Text("don't have an account ? SignUp !!"),
          ),
        ],
      ),
    );
  }
}
