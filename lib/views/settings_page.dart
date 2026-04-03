import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controlers/auth_controller.dart';
import '../controlers/home_controller.dart';
import '../main.dart'; // Pour le themeNotifier
import 'my_reports_page.dart';

/**
 * SettingsPage (Profil) - Espace personnel de l'éco-citoyen.
 * 
 * Affiche le résumé de l'engagement de l'utilisateur, ses points accumulés,
 * et permet de gérer ses préférences ou de se déconnecter.
 * Design conforme aux maquettes "Simple & Beau".
 */
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthController _authController = AuthController();
  final HomeController _homeController = HomeController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /**
   * Charge les données de profil et d'impact au démarrage.
   */
  Future<void> _loadProfileData() async {
    await _homeController.fetchUserStats();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['name']?.toString().toUpperCase() ?? "UTILISATEUR";

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /** En-tête Vert Premium */
            _buildProfileHeader(userName),
            
            /** Carte d'Impact (Points & KG) Dynamique */
            _isLoading 
              ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: Color(0xFF059669))))
              : _buildImpactStatsCard(_homeController),
            
            const SizedBox(height: 40),
            
            /** Liste d'options de navigation */
            _buildProfileMenuItem(
              icon: Icons.assignment_outlined,
              label: "MES SIGNALEMENTS",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyReportsPage()),
                );
              },
              isDark: isDark,
            ),
            _buildProfileMenuItem(
              icon: Icons.settings_outlined,
              label: "PARAMÈTRES",
              onTap: () => _showSettingsBottomSheet(context),
              isDark: isDark,
            ),
            
            const SizedBox(height: 10),
            
            /** Bouton Déconnexion (Rouge) */
            _buildLogoutButton(context),
            
            const SizedBox(height: 100), // Espace pour la barre de navigation
          ],
        ),
      ),
    );
  }

  /**
   * Construit la section supérieure avec l'avatar et le nom.
   */
  Widget _buildProfileHeader(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 60),
      decoration: const BoxDecoration(
        color: Color(0xFF059669), // Vert HYSACAM
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          /** Avatar "JD" Jaune Hysacam */
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white24, width: 4),
            ),
            child: const Center(
              child: Icon(Icons.person_outline_rounded, color: Color(0xFF059669), size: 50),
            ),
          ),
          const SizedBox(height: 20),
          /** Nom et Statut */
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const Text(
            "ÉCO-CITOYEN DOUALA",
            style: TextStyle(
              color: Color(0xFFD1FAE5),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Construit la carte flottante affichant les points et l'impact.
   */
  Widget _buildImpactStatsCard(HomeController controller) {
    return Transform.translate(
      offset: const Offset(0, -35),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildStatItem("POINTS", controller.getEcoPoints().toString(), const Color(0xFF059669)),
            Container(width: 1, height: 40, color: const Color(0xFFF1F5F9)),
            _buildStatItem("IMPACT", "-${controller.getCo2Impact()}Kg", const Color(0xFF1F2937)),
          ],
        ),
      ),
    );
  }

  /** Élément de statistique pour la carte d'impact */
  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF94A3B8),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  /** Item de menu cliquable stylisé */
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Icon(icon, color: const Color(0xFF1F2937)),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1F2937),
            letterSpacing: 1,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
      ),
    );
  }

  /** Bouton de déconnexion spécifique (Rouge) */
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () => _showLogoutDialog(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
        title: const Text(
          "DÉCONNEXION",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFFEF4444),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  /** Affiche un menu Paramètres glissant complet */
  void _showSettingsBottomSheet(BuildContext context) {
    bool pushNotificationsEnabled = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
            final bgColor = isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
            final textColor = isDarkTheme ? Colors.white : const Color(0xFF1F2937);

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 24),
                  Text("PARAMÈTRES", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textColor, letterSpacing: 1)),
                  const SizedBox(height: 30),
                  
                  Expanded(
                    child: ListView(
                      children: [
                        /** SECTION: APPARENCE */
                        _buildSettingSectionTitle("APPARENCE", isDarkTheme),
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: themeNotifier,
                          builder: (context, currentMode, child) {
                            final isDark = currentMode == ThemeMode.dark || 
                              (currentMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text("Mode Sombre", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                              subtitle: const Text("Apparence globale de l'app", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              value: isDark,
                              activeColor: const Color(0xFF059669),
                              onChanged: (val) {
                                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                                // Forcer le rafraîchissement local du BottomSheet pour la couleur des textes
                                setState(() {});
                              },
                              secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: isDark ? Colors.white : null),
                            );
                          },
                        ),
                        const Divider(height: 30, color: Colors.grey, thickness: 0.2),

                        /** SECTION: NOTIFICATIONS */
                        _buildSettingSectionTitle("NOTIFICATIONS", isDarkTheme),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("Alertes Push", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          subtitle: const Text("Suivi des ramassages", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          value: pushNotificationsEnabled,
                          activeColor: const Color(0xFF059669),
                          onChanged: (val) {
                            setState(() => pushNotificationsEnabled = val);
                          },
                          secondary: Icon(Icons.notifications_active_rounded, color: isDarkTheme ? Colors.white : null),
                        ),
                        const Divider(height: 30, color: Colors.grey, thickness: 0.2),

                        /** SECTION: ASSISTANCE & LÉGAL */
                        _buildSettingSectionTitle("ASSISTANCE", isDarkTheme),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.help_outline_rounded, color: isDarkTheme ? Colors.white : null),
                          title: Text("Centre d'Aide (FAQ)", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {}, // Fake action
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.shield_outlined, color: isDarkTheme ? Colors.white : null),
                          title: Text("Politique de confidentialité", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {}, // Fake action
                        ),
                        const SizedBox(height: 40),
                        
                        /** LÉGAL / SUPPRESSION DE COMPTE */
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.no_accounts_rounded, color: Colors.red),
                          title: const Text("Supprimer mon compte", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context); // Quitter le bottomsheet
                            // Pour afficher qu'on ne peut pas le faire facilement :
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contactez le support Hysacam pour supprimer le compte.")));
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text("CityReport v1.0.0", style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildSettingSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Color(0xFF059669),
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  /** Affiche une boîte de dialogue de confirmation avant déconnexion */
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 10),
              Text("Déconnexion", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          content: const Text(
            "Êtes-vous sûr de vouloir vous déconnecter de CityReport ?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULER", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Ferme la dialog
                _authController.logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("SE DÉCONNECTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}