import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/fixture.dart';
import 'helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(setupTestApp);
  tearDown(disposeFixture);

  testWidgets('fresh install shows splash then initial setup', (tester) async {
    await pumpTestApp(tester);
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.byKey(initialSetupKey), findsOneWidget);
  });
}
