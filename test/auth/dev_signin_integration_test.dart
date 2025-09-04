// ignore_for_file: avoid_print
/*
  DEV-only Supabase integration test.
  This test is manual and runs only when RUN_SUPABASE_INTEGRATION=1 is set.
  It attempts a signUp + signIn on your local Supabase instance using env/dev.json.
  Cleanup is intentionally omitted because the public SDK doesn't expose an admin delete API here.
*/
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_v2/services/supabase_service.dart';

void main() {
  const envFlag = String.fromEnvironment(
    'RUN_SUPABASE_INTEGRATION',
    defaultValue: '',
  );
  final runIntegration =
      envFlag == '1' || Platform.environment['RUN_SUPABASE_INTEGRATION'] == '1';

  test(
    'DEV Supabase sign-up + sign-in (manual run only)',
    () async {
      if (!runIntegration) {
        // skip the test unless explicitly enabled
        print(
          'Skipping Supabase integration test. Set RUN_SUPABASE_INTEGRATION=1 to run it.',
        );
        return;
      }

      // Load env/dev.json (must exist and contain SUPABASE_URL + SUPABASE_ANON_KEY)
      final envFile = File('env/dev.json');
      if (!await envFile.exists()) {
        fail(
          'env/dev.json not found. Create it with SUPABASE_URL and SUPABASE_ANON_KEY.',
        );
      }

      final map =
          jsonDecode(await envFile.readAsString()) as Map<String, dynamic>;
      final url = (map['SUPABASE_URL'] as String?) ?? '';
      final anon = (map['SUPABASE_ANON_KEY'] as String?) ?? '';
      if (url.isEmpty || anon.isEmpty) {
        fail('env/dev.json missing SUPABASE_URL or SUPABASE_ANON_KEY.');
      }

      // Initialize Supabase (idempotent)
      try {
        await SupabaseService().init(url: url, anonKey: anon);
      } catch (e) {
        fail('SupabaseService initialization failed: $e');
      }

      final client = Supabase.instance.client;
      final dynamic auth =
          client.auth; // dynamic to be resilient across SDK versions

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'flutter.dev+$timestamp@example.com';
      final testPassword = 'P@ssw0rd!$timestamp';

      print('Attempting signUp for $testEmail');

      try {
        // try common signUp API (may throw if SDK differs)
        await auth.signUp(email: testEmail, password: testPassword);
      } catch (e) {
        print(
          'signUp call failed with: $e (this may be OK if SDK uses a different API)',
        );
      }

      // Attempt sign-in using common method names
      dynamic signInResult;
      try {
        // new API (supabase-dart >= v1.0)
        signInResult = await auth.signInWithPassword(
          email: testEmail,
          password: testPassword,
        );
        print('signInWithPassword result: $signInResult');
      } catch (e) {
        print('signInWithPassword failed: $e; trying signIn(...) fallback');
        try {
          signInResult = await auth.signIn(
            email: testEmail,
            password: testPassword,
          );
          print('signIn(...) result: $signInResult');
        } catch (e2) {
          print('signIn fallback failed: $e2');
        }
      }

      // Inspect outcomes: try to detect a user/session in returned objects, or via client.auth.currentUser
      final dynCurrentUser = () {
        try {
          final cur = client.auth.currentUser;
          return cur;
        } catch (_) {
          try {
            return client.auth.currentSession?.user;
          } catch (_) {
            return null;
          }
        }
      }();

      print('client.auth.currentUser / session -> $dynCurrentUser');

      expect(
        dynCurrentUser != null || signInResult != null,
        isTrue,
        reason:
            'Expected to find a signed-in session/user or sign-in result. Check env/dev.json and that local Supabase is running.',
      );
    },
    timeout: Timeout(Duration(minutes: 2)),
  );
}
