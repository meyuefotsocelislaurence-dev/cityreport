import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controlers/auth_controller.dart';
import '../controlers/home_controller.dart';

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
    await _homeController.fetchRecentReports();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['name']?.toString().toUpperCase() ?? "UTILISATEUR";

    return Scaffold(
      backgroundColor: Colors.white,
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
                // Navigation vers l'historique (déjà géré par l'accueil)
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.settings_outlined,
              label: "PARAMÈTRES",
              onTap: () {
                // Options de réglages
              },
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
              color: const Color(0xFFFBBF24), // Jaune HYSACAM
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white24, width: 4),
            ),
            child: Center(
              child: Text(
                name.length >= 2 ? name.substring(0, 2) : "JD",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF059669),
                ),
              ),
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
          color: Colors.white,
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
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Icon(icon, color: const Color(0xFF1F2937)),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1F2937),
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
        onTap: () => _authController.logout(context),
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
}