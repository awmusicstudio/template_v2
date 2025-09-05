import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:template_v2/features/onboarding/join_code_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('LocalJoinCodeService creates and verifies join codes', () async {
    final service = LocalJoinCodeService();

    final code = await service.createStudio('My Test Studio');
    expect(code, isNotEmpty);
    expect(code.length, 6);

    final name = await service.verifyJoinCode(code);
    expect(name, 'My Test Studio');

    // Case-insensitive
    final lower = code.toLowerCase();
    final name2 = await service.verifyJoinCode(lower);
    expect(name2, 'My Test Studio');

    final missing = await service.verifyJoinCode('ABC999');
    expect(missing, isNull);
  });

  test('verifyJoinCode returns null for empty input', () async {
    final service = LocalJoinCodeService();
    final res = await service.verifyJoinCode('   ');
    expect(res, isNull);
  });
}
