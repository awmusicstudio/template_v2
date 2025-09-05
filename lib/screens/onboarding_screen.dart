import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _studioController = TextEditingController();
  final _codeController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _studioController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingProvider);
    final role = ref.watch(onboardingRoleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Role:'),
                const SizedBox(width: 12),
                SegmentedButton<OnboardingRole>(
                  segments: const [
                    ButtonSegment(
                      value: OnboardingRole.admin,
                      label: Text('Admin'),
                    ),
                    ButtonSegment(
                      value: OnboardingRole.client,
                      label: Text('Client'),
                    ),
                  ],
                  selected: {role},
                  onSelectionChanged: (sel) {
                    if (sel.isNotEmpty) {
                      ref.read(onboardingRoleProvider.notifier).state =
                          sel.first;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (role == OnboardingRole.admin) ...[
              const Text('Create Studio'),
              TextField(
                controller: _studioController,
                decoration: const InputDecoration(hintText: 'Studio name'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _busy
                    ? null
                    : () async {
                        final name = _studioController.text.trim();
                        if (name.isEmpty) {
                          _showSnack('Enter a studio name');
                          return;
                        }
                        final messenger = ScaffoldMessenger.of(context);
                        final router = GoRouter.of(context);
                        setState(() => _busy = true);
                        try {
                          final code = await onboarding.createStudio(name);
                          // Persist role as admin and complete onboarding
                          ref.read(onboardingRoleProvider.notifier).state =
                              OnboardingRole.admin;
                          await onboarding.completeOnboarding();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Created. Join code: $code'),
                            ),
                          );
                          router.go('/');
                        } catch (e) {
                          _showSnack('Failed to create studio: $e');
                        } finally {
                          if (mounted) setState(() => _busy = false);
                        }
                      },
                child: const Text('Create & Continue'),
              ),
            ] else ...[
              const Text('Join with Code (optional)'),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  hintText: 'Enter join code (optional)',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _busy
                    ? null
                    : () async {
                        final code = _codeController.text.trim();
                        final messenger = ScaffoldMessenger.of(context);
                        final router = GoRouter.of(context);
                        setState(() => _busy = true);
                        try {
                          if (code.isNotEmpty) {
                            final name = await onboarding.verifyJoinCode(code);
                            if (name == null) {
                              messenger.showSnackBar(
                                const SnackBar(content: Text('Invalid code')),
                              );
                              return;
                            } else {
                              messenger.showSnackBar(
                                SnackBar(content: Text('Joined "$name"')),
                              );
                            }
                          }
                          // Persist role as client and complete onboarding
                          ref.read(onboardingRoleProvider.notifier).state =
                              OnboardingRole.client;
                          await onboarding.completeOnboarding();
                          router.go('/');
                        } catch (e) {
                          _showSnack('Error: $e');
                        } finally {
                          if (mounted) setState(() => _busy = false);
                        }
                      },
                child: const Text('Continue'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
