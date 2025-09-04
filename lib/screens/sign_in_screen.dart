// lib/screens/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/features/auth/auth_controller.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _pwCtl = TextEditingController();
  bool _loading = false;
  bool _isSignUp = false; // false => Sign In mode, true => Create Account mode

  @override
  void dispose() {
    _emailCtl.dispose();
    _pwCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailCtl.text.trim();
    final pw = _pwCtl.text;
    setState(() => _loading = true);

    final notifier = ref.read(authControllerProvider.notifier);
    bool ok = false;
    String successMsg = '';
    String failMsg = 'Operation failed';

    if (_isSignUp) {
      successMsg = 'Account creation requested';
      failMsg = 'Create account failed';
      ok = await notifier.signUpWithEmail(email, pw);
    } else {
      successMsg = 'Sign-in successful';
      failMsg = 'Sign-in failed';
      ok = await notifier.signInWithEmail(email, pw);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(ok ? successMsg : failMsg)));

    // If sign-in succeeded, AuthController will update state and router will redirect.
    setState(() => _loading = false);
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pwCtl,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (v) {
                          if (!_isSignUp) {
                            // sign-in requires a password
                            if (v == null || v.isEmpty) return 'Required';
                          } else {
                            // for sign-up we allow empty (depends on your policy)
                            if (v == null || v.isEmpty) return 'Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _submit,
                                child: Text(
                                  _isSignUp ? 'Create an Account' : 'Sign In',
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(
                          _isSignUp
                              ? 'Have an account? Sign In'
                              : 'Need an account? Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
