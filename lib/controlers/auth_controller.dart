import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/**
 * AuthController - Gestionnaire de l'authentification.
 * 
 * Centralise les appels à l'API Supabase pour la connexion, l'inscription
 * et la déconnexion. Gère également l'affichage des alertes utilisateur épurées.
 */
class AuthController {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  /**
   * Inscrit un nouvel utilisateur et enregistre ses métadonnées.
   */
  Future<bool> register(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      _showProfessionalAlert(context, "Veuillez remplir tous les champs obligatoires", Colors.orange);
      return false;
    }

    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone},
      );

      if (res.user != null) {
        _showProfessionalAlert(context, "Inscription réussie. Vérifiez votre boîte e-mail.", Colors.green);
        if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
        return true;
      }
      return false;
    } on AuthException catch (e) {
      _showProfessionalAlert(context, e.message, Colors.red);
      return false;
    } catch (e) {
      _showProfessionalAlert(context, "Une erreur inattendue est survenue", Colors.red);
      return false;
    }
  }

  /**
   * Connecte l'utilisateur via Email/Mot de passe.
   */
  Future<bool> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showProfessionalAlert(context, "Identifiants manquants", Colors.orange);
      return false;
    }

    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session != null) {
        _showProfessionalAlert(context, "Connexion établie", Colors.green);
        if (context.mounted) Navigator.pushReplacementNamed(context, '/main');
        return true;
      }
      return false;
    } on AuthException catch (e) {
      _showProfessionalAlert(context, "Identifiants incorrects", Colors.red);
      return false;
    } catch (e) {
      _showProfessionalAlert(context, "Erreur de connexion", Colors.red);
      return false;
    }
  }

  /**
   * Déconnecte l'utilisateur et ferme la session.
   */
  Future<void> logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  /**
   * Affiche une alerte Snack-bar épurée sans emoji.
   */
  void _showProfessionalAlert(BuildContext context, String message, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
