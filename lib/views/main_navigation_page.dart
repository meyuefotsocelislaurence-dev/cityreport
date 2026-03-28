import 'package:flutter/material.dart';
import 'home_page.dart'; // À créer : résumé des signalements
import 'map_page.dart';  // À créer : localisation
import 'add_report_page.dart'; 
import 'settings_page.dart'; // À créer : paramètres

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // Liste des pages
  final List<Widget> _pages = [
    const HomePage(),        // Index 0
    const MapPage(),         // Index 1
    const AddReportPage(),   // Index 2
    const SettingsPage(),    // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Carte"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Signaler"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Réglages"),
        ],
      ),
    );
  }
}