import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'services/settings_service.dart';

const supabaseUrl = 'https://kjrdothkpcedzrjdwko.supabase.co';
const supabaseKey = 'sb_publishable_GIMrjzUPf7zl1Xo0m6Jriw_-EmSKhtg';

const green = Color(0xFF067A0A);
const orange = Color(0xFFFF7A00);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  SettingsService.instance.start(); // realtime: rates + payment methods
  runApp(const Be3lyApp());
}

class Be3lyApp extends StatelessWidget {
  const Be3lyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData theme(Brightness b) => ThemeData(
          brightness: b,
          colorScheme: ColorScheme.fromSeed(seedColor: green, secondary: orange, brightness: b),
          textTheme: GoogleFonts.cairoTextTheme(ThemeData(brightness: b).textTheme),
          useMaterial3: true,
        );
    return MaterialApp(
      title: 'بعلي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}