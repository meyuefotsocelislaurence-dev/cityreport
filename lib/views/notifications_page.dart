import 'package:flutter/material.dart';

/**
 * NotificationsPage - Centre de notifications citoyen.
 * 
 * Affiche les alertes importantes relatives au ramassage des déchets,
 * aux interventions de HYSACAM et aux récompenses gagnées.
 * Design conforme aux maquettes "Simple & Beau".
 */
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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

              /** Liste de Notifications */
              _buildNotificationCard(
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF059669),
                title: "SIGNALEMENT RÉSOLU",
                description: "Les ordures à Bali ont été ramassées avec succès. Merci !",
                points: "+10 Eco-Points gagnés",
              ),
              
              const SizedBox(height: 20),
              
              _buildNotificationCard(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFFFBBF24),
                title: "PASSAGE HYSACAM",
                description: "Le ramassage dans votre zone est prévu demain à 08:00.",
              ),
              
              const SizedBox(height: 20),
              
              /** Notification Archivée (Optionnel) */
              _buildNotificationCard(
                icon: Icons.eco_outlined,
                iconColor: Colors.blue,
                title: "NOUVEAU BADGE",
                description: "Vous avez débloqué le badge 'Citoyen Actif' !",
              ),
              
              const SizedBox(height: 100), // Espace pour la navigation
            ],
          ),
        ),
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
