import 'package:flutter/material.dart';

/**
 * NotificationsPage - Centre d'alertes citoyen.
 * 
 * Affiche les notifications relatives aux suivis de signalements 
 * (Changement de statut, intervention HYSACAM, gains de points).
 */
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "ALERTES",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildNotificationItem(
            icon: Icons.check_circle_outline,
            color: const Color(0xFF059669),
            title: "Signalement traité !",
            description: "HYSACAM a collecté les déchets à Akwa. Merci pour votre aide !",
            time: "Il y a 2h",
            isNew: true,
          ),
          _buildNotificationItem(
            icon: Icons.local_shipping_outlined,
            color: const Color(0xFFFBBF24),
            title: "Camion en route",
            description: "Une équipe arrive dans 15 min pour votre signalement à Bali.",
            time: "Il y a 45 min",
            isNew: true,
          ),
          _buildNotificationItem(
            icon: Icons.card_giftcard_outlined,
            color: Colors.blue,
            title: "+10 Eco-Points gagnés",
            description: "Félicitations ! Votre action citoyenne a été récompensée.",
            time: "Hier",
            isNew: false,
          ),
        ],
      ),
    );
  }

  /**
   * Construit un élément de liste de notification avec badge "Nouveau".
   */
  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /** Icône avec fond léger */
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          /** Core Text */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                    ),
                    if (isNew)
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
