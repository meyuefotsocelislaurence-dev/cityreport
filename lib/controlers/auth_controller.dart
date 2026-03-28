import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final supabase = Supabase.instance.client;

  // Les contrôleurs de texte pour récupérer ce que l'utilisateur tape
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<bool> register(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez remplir tous les champs"),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return false;
    }

    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phoneController.text.trim()},
      );

      if (res.user != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "✅ Inscription réussie ! Vérifiez votre boîte e-mail.",
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("⚠️ Échec de l'inscription. Veuillez réessayer."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } on AuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur auth : ${error.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur interne : ${error.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  Future<bool> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur : merci de renseigner email et mot de passe"),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return false;
    }

    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session != null && res.user != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("🎉 Bienvenue ! Vous êtes connecté."),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacementNamed(context, '/main');
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Identifiants non valides. Vérifier votre email/mot de passe.",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } on AuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur Supabase : ${error.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la connexion : ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  bool isLoggedIn() {
    return supabase.auth.currentSession != null;
  }
}
