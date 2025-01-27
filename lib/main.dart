import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: <Locale>[
        const Locale('cs', 'CZ'),
        const Locale('en', 'GB'),
        const Locale('de', 'DE')
      ],
    );
  }
}
