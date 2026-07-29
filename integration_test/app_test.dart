import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(setupTestApp);
  tearDown(() => getIt.reset());

  testWidgets('fresh install shows splash then initial setup', (tester) async {
    await pumpTestApp(tester);
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.byKey(Key('value')), findsOneWidget);
  });
}
