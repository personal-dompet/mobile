import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> setupTestApp() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await getIt.reset();
  await initDependency(dbTestPath: inMemoryDatabasePath);
}

Future<void> pumpTestApp(WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pump();
  await tester.pump(const Duration(seconds: 3));
}
