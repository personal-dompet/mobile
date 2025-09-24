// lib/main.dart
import 'package:dompet/router.dart';
import 'package:dompet/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

// import 'presentation/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await initializeDateFormatting('id_ID');
  // final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const DompetApp(),
    ),
  );
}

class DompetApp extends StatelessWidget {
  const DompetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: MaterialApp.router(
          title: 'Dompet',
          theme: AppThemes.darkTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
