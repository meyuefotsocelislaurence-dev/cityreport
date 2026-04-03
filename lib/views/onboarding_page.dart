import 'package:flutter/material.dart';
import 'login_page.dart';

/**
 * OnboardingPage - Tutoriel interactif de l'application CityReport.
 * 
 * Cet écran présente les 3 piliers de l'application aux nouveaux utilisateurs :
 * 1. Le signalement simple des déchets.
 * 2. Le suivi en temps réel par les équipes HYSACAM.
 * 3. Le programme de récompenses Eco-Points.
 */
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /**
   * Données des pages de tutoriel
   */
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Agissez pour Douala",
      "description": "Prenez une photo d'un dépôt sauvage et HYSACAM intervient en 24h.",
      "icon": "vire_trash_2", // Alias Lucide
      "color": "0xFF059669",
    },
    {
      "title": "Suivez en temps réel",
      "description": "Recevez des notifications sur l'avancement du ramassage dans votre quartier.",
      "icon": "truck",
      "color": "0xFFFBBF24",
    },
    {
      "title": "Gagnez des points éco",
      "description": "Chaque signalement vous rapporte des points pour devenir un éco-citoyen modèle.",
      "icon": "award",
      "color": "0xFF059669",
    },
  ];

  /**
   * Finalise le tutoriel et redirige vers la page de Connexion.
   */
  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Stack(
        children: [
          /** Content PageView */
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildOnboardingScreen(index);
            },
          ),
          
          /** Pagination et bouton Suivant en bas */
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Column(
              children: [
                /** Indicateurs de page */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? const Color(0xFF059669) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                /** Bouton principal d'action */
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : const Color(0xFF1F2937),
                      foregroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingData.length - 1 ? "COMMENCER" : "SUIVANT",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
                
                /** Bouton Passer */
                if (_currentPage != _onboardingData.length - 1)
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      "PASSER",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Widget de construction d'un écran d'onboarding spécifique.
   */
  Widget _buildOnboardingScreen(int index) {
    final data = _onboardingData[index];
    final Color mainColor = Color(int.parse(data['color']!));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /** Illustration Stylisée */
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              index == 0 ? Icons.delete_outline : (index == 1 ? Icons.local_shipping_outlined : Icons.emoji_events_outlined),
              size: 100,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 60),
          
          /** Titre descriptif */
          Text(
            data['title']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
              letterSpacing: -1.0,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          
          /** Description détaillée */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              data['description']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
