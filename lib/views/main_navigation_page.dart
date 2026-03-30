import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'map_page.dart';  
import 'add_report_page.dart'; 
import 'settings_page.dart'; 
import 'notifications_page.dart';

/**
 * MainNavigationPage - Conteneur principal de navigation.
 * 
 * Gère le changement de vues via une barre de navigation inférieure stylisée
 * et un bouton central (FloatingActionButton) pour le signalement rapide.
 */
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  /**
   * Pages de l'application (correspondant aux 4 icônes de la barre)
   */
  final List<Widget> _pages = [
    const HomePage(),           // 0: Accueil
    const MapPage(),            // 1: Carte
    const NotificationsPage(),  // 2: Alertes
    const SettingsPage(),       // 3: Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Permet au contenu de passer sous la barre de navigation translucide
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      
      /** Bouton Central de Signalement (Jaune Hysacam) */
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ouvre la page de signalement en mode plein écran / modal
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReportPage()),
          );
        },
        backgroundColor: const Color(0xFFFBBF24), // Jaune Hysacam
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add, size: 32, color: Color(0xFF059669)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      /** Barre de Navigation Stylisée */
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: Colors.white,
        elevation: 30,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_filled, "Accueil"),
              _buildNavItem(1, Icons.map_outlined, "Carte"),
              const SizedBox(width: 40), // Espace pour le FAB
              _buildNavItem(2, Icons.notifications_none_rounded, "Alertes"),
              _buildNavItem(3, Icons.person_outline_rounded, "Profil"),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Widget utilitaire pour construire un élément de navigation.
   */
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF059669) : const Color(0xFF94A3B8),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? const Color(0xFF059669) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}