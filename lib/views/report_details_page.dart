import 'package:flutter/material.dart';
import '../models/report_model.dart';

/**
 * ReportDetailsPage - Vue de suivi granulaire d'un signalement.
 * 
 * Permet au citoyen de voir l'état exact de son signalement et d'échanger
 * des messages (chat) avec les équipes de HYSACAM.
 * Design conforme aux maquettes "Simple & Beau".
 */
class ReportDetailsPage extends StatefulWidget {
  final ReportModel report;

  const ReportDetailsPage({super.key, required this.report});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "SUIVI DE SIGNALEMENT",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /** Carte de Statut du Signalement */
          _buildStatusHeader(),
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          /** Zone de Chat / Historique Messages */
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildChatMessage(
                  sender: "ADMIN HYSACAM",
                  message: "Bonjour Jean, nos équipes de ramassage sont en route vers votre position à Akwa.",
                  time: "09:24",
                  isAdmin: true,
                ),
                _buildChatMessage(
                  sender: "VOUS",
                  message: "Super, merci pour cette réactivité !",
                  time: "09:40",
                  isAdmin: false,
                ),
              ],
            ),
          ),

          /** Champ de saisie du message (Bas de page) */
          _buildMessageInput(),
        ],
      ),
    );
  }

  /**
   * Construit l'en-tête avec les détails du signalement.
   */
  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          /** Thumbnail du rapport */
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.report.imageUrl,
              width: 70, height: 70, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          /** Titre et Statut */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.report.typeInsalubrite.toUpperCase(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 6),
                Text(
                  "STATUS: ${widget.report.statut.toUpperCase()}",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Construit une bulle de chat stylisée.
   */
  Widget _buildChatMessage({
    required String sender,
    required String message,
    required String time,
    required bool isAdmin,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          /** Bulle de message */
          Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: isAdmin ? const Color(0xFFF1F5F9) : const Color(0xFF059669),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomLeft: Radius.circular(isAdmin ? 5 : 25),
                bottomRight: Radius.circular(isAdmin ? 25 : 5),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isAdmin ? const Color(0xFF1F2937) : Colors.white,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          /** Libellé Emetteur + Heure */
          Text(
            "$sender • $time",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFCBD5E1), letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  /**
   * Construit le champ de texte flottant pour envoyer un message.
   */
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, -10)),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Écrire un message...",
                    hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            /** Bouton d'envoi vert circulaire */
            Container(
              decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  // Logique d'envoi à Supabase (comments table)
                  _messageController.clear();
                },
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
