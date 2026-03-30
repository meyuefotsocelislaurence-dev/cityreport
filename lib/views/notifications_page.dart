import 'package:flutter/material.dart';

/**
 * NotificationsPage - Centre de notifications citoyen.
 * 
 * Affiche les alertes importantes relatives au ramassage des déchets,
 * aux interventions de HYSACAM et aux récompenses gagnées.
 * Design conforme aux maquettes "Simple & Beau".
 */
import '../controlers/home_controller.dart';
import '../models/report_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final HomeController _homeController = HomeController();
  List<ReportModel> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  /**
   * Charge les rapports pour simuler des notifications de statut.
   */
  Future<void> _loadNotifications() async {
    await _homeController.fetchUserStats();
    final data = _homeController.userReports; // Les notifications sont basées sur mes rapports
    if (mounted) {
      setState(() {
        _reports = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /** Titre de la page */
              const Text(
                "NOTIFICATIONS",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 40),

              /** Notification de Bienvenue Statique */
              _buildNotificationCard(
                icon: Icons.eco_outlined,
                iconColor: const Color(0xFF059669),
                title: "BIENVENUE SUR CITYREPORT",
                description: "Merci de rejoindre la communauté pour une ville de Douala plus propre.",
              ),
              
              const SizedBox(height: 20),

              /** Liste Dynamique basée sur les signalements */
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: Color(0xFF059669)))
              else if (_reports.isEmpty)
                _buildEmptyNotifications()
              else
                Column(
                  children: _reports.map((report) {
                    final isResolved = report.statut.toLowerCase() == "résolu";
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildNotificationCard(
                        icon: isResolved ? Icons.check_circle_outline_rounded : Icons.history_rounded,
                        iconColor: isResolved ? const Color(0xFF059669) : const Color(0xFFFBBF24),
                        title: "SIGNALEMENT ${report.statut.toUpperCase()}",
                        description: "Votre signalement '${report.typeInsalubrite}' est ${report.statut.toLowerCase()}.",
                        points: isResolved ? "+50 Eco-Points gagnés" : null,
                      ),
                    );
                  }).toList(),
                ),
              
              const SizedBox(height: 100), // Espace pour la navigation
            ],
          ),
        ),
      ),
    );
  }

  /** UI : Message si aucune notification */
  Widget _buildEmptyNotifications() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.notifications_none_rounded, size: 60, color: Colors.grey[200]),
          const SizedBox(height: 20),
          const Text(
            "Aucune nouvelle alerte pour le moment.",
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /**
   * Construit une carte de notification stylisée selon la maquette.
   */
  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    String? points,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /** Icône avec fond léger circulaire */
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 20),
          /** Contenu de la Notification */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                /** Optionnel : Affichage des Eco-Points gagnés */
                if (points != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    points,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
