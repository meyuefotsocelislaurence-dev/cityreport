import 'package:flutter/material.dart';
import '../views/main_navigation_page.dart'; // À créer : page de navigation principale après connexion

class AuthController {
  // Les contrôleurs de texte pour récupérer ce que l'utilisateur tape
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register(BuildContext context) {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      // Ici, vous ajouterez plus tard la logique de connexion à votre base de données
      print("Inscription de $name...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscription réussie !")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }
  // Ajoutez ceci dans votre classe AuthController
void login(BuildContext context) {
  String email = emailController.text;
  String password = passwordController.text;

  if (email.isNotEmpty && password.isNotEmpty) {
    // Simulation d'une connexion réussie
    print("Connexion de $email...");
    
    // Après connexion, on dirige vers la page de signalement (à créer)
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Connexion réussie !")),
      
    );
    Navigator.pushReplacement(
    context, 
    MaterialPageRoute(builder: (context) => const MainNavigationPage())
  );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erreur : Identifiants vides")),
    );
  }
}
}