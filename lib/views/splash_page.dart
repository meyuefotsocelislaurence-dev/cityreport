import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding_page.dart';
import 'main_navigation_page.dart';

/**
 * SplashPage - Écran de démarrage de l'application CityReport.
 * 
 * Cet écran affiche l'identité visuelle de HYSACAM pendant le chargement
 * initial de l'application. Il gère également la redirection vers le
 * tutoriel (Onboarding), la Connexion ou le Dashboard selon l'état de la session.
 */
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  /**
   * Simule un chargement et gère la logique de navigation après 3 secondes.
   */
  void _startLoading() {
    // Animation de la barre de progression
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted) {
        setState(() {
          if (_progressValue < 1.0) {
            _progressValue += 0.01;
          } else {
            timer.cancel();
            _completeLoading();
          }
        });
      }
    });
  }

  /**
   * Vérifie l'état de l'utilisateur et redirige vers la page appropriée.
   */
  void _completeLoading() {
    final session = Supabase.instance.client.auth.currentSession;
    
    // Pour les besoins de la démo/soutenance, on peut aussi forcer l'onboarding
    // mais ici on suit une logique standard de session.
    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationPage()),
      );
    } else {
      // Redirige vers l'Onboarding par défaut pour les nouveaux utilisateurs
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF059669), // Sombre ou Vert Hysacam
      body: Stack(
        children: [
          // Contenu Central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /** Logo dans un cadre blanc premium */
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121212) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 30),
                
                /** Nom de l'app */
                const Text(
                  "CityReport",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),
                
                /** Slogan */
                const Text(
                  "Rendons Douala plus propre, ensemble.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFD1FAE5), // Emerald-100
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          /** Barre de progression en bas */
          Positioned(
            bottom: 80,
            left: 50,
            right: 50,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)), // Jaune Hysacam
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "CHARGEMENT...",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
