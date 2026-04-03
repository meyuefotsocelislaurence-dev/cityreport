import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/main_navigation_page.dart';
import 'views/add_report_page.dart';
import 'views/splash_page.dart';
import 'views/onboarding_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/**
 * CityReport - Application de signalement citoyen pour HYSACAM.
 * 
 * L'application permet aux citoyens de Douala de signaler des problèmes 
 * d'insalubrité urbaine en temps réel via Supabase.
 */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jwuoqvssubxnzeptqmyk.supabase.co',
    anonKey: 'sb_publishable_xx2wz-wvc2_LUGQcZLyAbA_dzClceuM',
  );

  runApp(const CityReportApp());
}

final supabase = Supabase.instance.client;

/** Notifier global pour gérer le changement de thème instantané */
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class CityReportApp extends StatelessWidget {
  const CityReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'CityReport',
          debugShowCheckedModeBanner: false,

          /** --- 1. CONFIGURATION DU THÈME CLAIR ---  */
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF059669), // Vert Hysacam
              brightness: Brightness.light, 
              primary: const Color(0xFF059669),
              secondary: const Color(0xFFFBBF24), // Jaune Hysacam
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF059669),
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          ),

          // --- 2. CONFIGURATION DU THÈME SOMBRE ---
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF059669),
              brightness: Brightness.dark,
              primary: const Color(0xFF059669),
              secondary: const Color(0xFFFBBF24),
              surface: const Color(0xFF121212),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),

          themeMode: currentMode,

          /** Point d'entrée : On commence toujours par le Splash Screen */
          home: const SplashPage(),

          routes: {
            '/splash': (context) => const SplashPage(),
            '/onboarding': (context) => const OnboardingPage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/main': (context) => const MainNavigationPage(),
            '/add-report': (context) => const AddReportPage(),
          },

          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const LoginPage());
          },
        );
      },
    );
  }
}
