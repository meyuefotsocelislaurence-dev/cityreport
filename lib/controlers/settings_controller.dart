import 'package:flutter/material.dart';
import '../views/login_page.dart';

class SettingsController {
  // Fonction pour se déconnecter
  void logout(BuildContext context) {
    // Ici, vous pourriez ajouter la logique pour vider la session (ex: SharedPreferences ou Firebase SignOut)
    
    // Redirection vers la page de connexion en vidant la pile de navigation
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  // Fonction pour simuler la mise à jour du profil
  void updateProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil mis à jour avec succès")),
    );
  }
}