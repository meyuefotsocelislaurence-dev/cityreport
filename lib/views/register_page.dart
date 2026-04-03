import 'package:flutter/material.dart';
import '../controlers/auth_controller.dart';

/**
 * RegisterPage - Écran d'inscription utilisateur.
 * 
 * Permet aux nouveaux citoyens de rejoindre CityReport.
 * Design épuré "Simple & Beau" avec les champs requis par Supabase :
 * - Nom Complet (full_name)
 * - Téléphone (phone)
 * - Email (email)
 */
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  /**
   * Lance la procédure d'inscription via le controller.
   */
  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    final success = await _authController.register(context);
    if (mounted) setState(() => _isLoading = false);
    
    if (success) {
      // Le controller gère déjà la redirection vers /login en cas de succès
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /** Titre de Bienvenue */
              Text(
                "Bienvenue.",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Inscrivez-vous pour commencer à protéger votre quartier.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 50),

              /** Formulaire d'inscription */
              _buildFieldLabel("NOM COMPLET"),
              _buildTextField(
                controller: _authController.nameController,
                hintText: "Jean Douala",
                icon: Icons.person_outline,
                isDark: isDark,
              ),
              
              const SizedBox(height: 25),
              _buildFieldLabel("TÉLÉPHONE"),
              _buildTextField(
                controller: _authController.phoneController,
                hintText: "+237 600 000 000",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                isDark: isDark,
              ),

              const SizedBox(height: 25),
              _buildFieldLabel("EMAIL (OPTIONNEL)"),
              _buildTextField(
                controller: _authController.emailController,
                hintText: "jean@exemple.com",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isDark: isDark,
              ),

              const SizedBox(height: 25),
              _buildFieldLabel("MOT DE PASSE"),
              _buildTextField(
                controller: _authController.passwordController,
                hintText: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
                isDark: isDark,
              ),

              const SizedBox(height: 40),
              
              /** Bouton S'inscrire */
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
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
                          "S'INSCRIRE",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              
              /** Lien de connexion */
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                      children: [
                        TextSpan(text: "Déjà inscrit ? "),
                        TextSpan(
                          text: "Se connecter",
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
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1F2937)),
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
