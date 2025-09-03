import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/auth_controller.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (authState.status == AuthStatus.signedIn)
                const Text('Signed in')
              else
                const Text('Please sign in to continue'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // dev flow: call checkSession (replace with real sign-in in next ticket)
                  await ref
                      .read(authControllerProvider.notifier)
                      .checkSession();
                },
                child: const Text('Check session'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  // placeholder: in future ticket we'll wire up email / OAuth flows
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                child: const Text('Sign out (dev)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
