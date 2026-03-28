import 'package:flutter/material.dart';

class NavigationController {
  int currentIndex = 0;

  // Liste des titres pour l'AppBar selon la page
  final List<String> titles = [
    "Accueil CityReport",
    "Localisation",
    "Nouveau Signalement",
    "Paramètres"
  ];

  String get currentTitle => titles[currentIndex];
}