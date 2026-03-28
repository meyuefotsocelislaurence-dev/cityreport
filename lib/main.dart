import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/main_navigation_page.dart';
import 'views/add_report_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jwuoqvssubxnzeptqmyk.supabase.co',
    anonKey: 'sb_publishable_xx2wz-wvc2_LUGQcZLyAbA_dzClceuM',
  );

  runApp(const CityReportApp());
}

final supabase = Supabase.instance.client;

class CityReportApp extends StatelessWidget {
  const CityReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityReport',
      debugShowCheckedModeBanner: false,

      /** --- 1. CONFIGURATION DU THÈME CLAIR ---  */
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light, // Mode clair
          primary: Colors.green,
          secondary: Colors.orangeAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),

      // --- 2. CONFIGURATION DU THÈME SOMBRE ---
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark, // Mode sombre
          primary: Colors.green,
          secondary: Colors.orangeAccent,
          surface: const Color(0xFF121212), // Fond gris foncé standard
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),

      // --- 3. GESTION AUTOMATIQUE ---
      // L'application suivra les réglages du téléphone (Clair ou Sombre)
      themeMode: ThemeMode.system,

      // Vérifier la session et rediriger
      home: supabase.auth.currentSession != null
          ? const MainNavigationPage()
          : LoginPage(),

      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => const MainNavigationPage(),
        '/add-report': (context) => const AddReportPage(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginPage());
      },
    );
  }
}
