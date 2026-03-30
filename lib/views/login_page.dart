import 'package:flutter/material.dart';
import '../controlers/auth_controller.dart';
import 'register_page.dart';

/**
 * LoginPage - Écran de connexion utilisateur.
 * 
 * Permet aux citoyens de s'authentifier via Supabase.
 * Design épuré "Simple & Beau" avec les champs requis :
 * - Email
 * - Mot de passe
 */
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  /**
   * Lance la procédure de connexion via le controller.
   */
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    final success = await _authController.login(context);
    if (mounted) setState(() => _isLoading = false);
    
    if (success) {
      // Le controller gère déjà la redirection vers /main en cas de succès
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /** Titre de Bienvenue */
              const Text(
                "Bienvenue.",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Connectez-vous pour signaler et suivre l'insalubrité dans votre quartier.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 60),

              /** Formulaire de connexion */
              _buildFieldLabel("EMAIL"),
              _buildTextField(
                controller: _authController.emailController,
                hintText: "Saisissez votre email",
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 25),
              _buildFieldLabel("MOT DE PASSE"),
              _buildTextField(
                controller: _authController.passwordController,
                hintText: "Saisissez votre mot de passe",
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),

              const SizedBox(height: 40),
              
              /** Bouton Se Connecter */
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669), // Vert Hysacam
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "SE CONNECTER",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              
              /** Lien vers l'inscription */
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                      children: [
                        TextSpan(text: "Pas encore de compte ? "),
                        TextSpan(
                          text: "S'inscrire",
                          style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Construit un label de champ en majuscules grisées.
   */
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xFF94A3B8),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  /**
   * Construit un champ de saisie stylisé "Simple & Beau".
   */
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}
