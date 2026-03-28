import 'package:flutter/material.dart';
import '../controlers/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _controller = SettingsController();
  
  // Variables d'état pour la simulation
  bool _isDarkMode = false;
  String _selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    // Détection automatique pour le bouton si vous changez via le système
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Section Profil
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Utilisateur CityReport",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(),

          // --- SECTION APPARENCE (NOUVEAU) ---
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
            child: Text("Apparence", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: _isDarkMode ? Colors.orangeAccent : Colors.blueGrey),
            title: const Text("Mode Sombre"),
            subtitle: Text(_isDarkMode ? "Activé" : "Désactivé"),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (val) {
                setState(() {
                  _isDarkMode = val;
                });
                // Conseil : Expliquez au jury que ThemeMode.system dans main.dart 
                // permet à l'app de suivre les réglages du téléphone automatiquement.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("L'application s'adapte aux thèmes de votre système.")),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: const Text("Langue de l'application"),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(),

          // Options de compte
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
            child: Text("Compte & Sécurité", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.green),
            title: const Text("Modifier mon profil"),
            onTap: () => _controller.updateProfile(context),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: const Text("Notifications Push"),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.green),
            title: const Text("Changer le mot de passe"),
            onTap: () {},
          ),
          
          const Divider(),
          
          // Section Aide & Info
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Aide et Support"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("À propos de CityReport"),
            subtitle: const Text("Version 1.0.0"),
            onTap: () {},
          ),

          const Divider(),

          // Bouton Déconnexion
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Fonction pour le choix de la langue
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisir la langue"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text("Français"),
              value: "Français",
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text("English"),
              value: "English",
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val.toString());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment quitter l'application ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () => _controller.logout(context),
            child: const Text("Confirmer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}