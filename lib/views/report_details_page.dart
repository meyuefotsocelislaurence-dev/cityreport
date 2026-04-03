import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/report_model.dart';
import '../models/comment_model.dart';
import '../controlers/comment_controller.dart';
import 'package:intl/intl.dart';

/**
 * ReportDetailsPage - Vue de suivi granulaire d'un signalement.
 * 
 * Permet au citoyen de voir l'état exact de son signalement, de visualiser
 * l'emplacement sur une carte et d'échanger des messages avec HYSACAM.
 */
class ReportDetailsPage extends StatefulWidget {
  final ReportModel report;

  const ReportDetailsPage({super.key, required this.report});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  final CommentController _commentController = CommentController();
  final TextEditingController _messageController = TextEditingController();
  List<CommentModel> _comments = [];
  bool _isMessagesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  /**
   * Récupère les messages réels du signalement depuis Supabase.
   */
  Future<void> _loadComments() async {
    if (widget.report.id == null) return;
    final data = await _commentController.fetchComments(widget.report.id!);
    if (mounted) {
      setState(() {
        _comments = data;
        _isMessagesLoading = false;
      });
    }
  }

  /**
   * Action : Envoyer un message à Supabase.
   */
  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || widget.report.id == null) return;

    final success = await _commentController.sendComment(widget.report.id!, content);
    if (success) {
      _messageController.clear();
      _loadComments(); // Recharger pour voir le nouveau message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          (widget.report.title ?? "SIGNALEMENT").toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /** Carte & Position Interactive */
          _buildMapHeader(),
          
          /** En-tête Statut & Détails */
          _buildStatusHeader(),
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          /** Zone de Discussion */
          Expanded(
            child: _isMessagesLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF059669)))
              : _comments.isEmpty
                ? _buildEmptyMessages()
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _buildChatMessage(
                        sender: comment.isAdmin ? "ADMIN HYSACAM" : "VOUS",
                        message: comment.content,
                        time: DateFormat('HH:mm').format(comment.createdAt),
                        isAdmin: comment.isAdmin,
                      );
                    },
                  ),
          ),

          /** Champ de saisie du message */
          _buildMessageInput(),
        ],
      ),
    );
  }

  /**
   * UI : Mini carte interactive montrant la localisation du signalement.
   */
  Widget _buildMapHeader() {
    final location = LatLng(widget.report.latitude, widget.report.longitude);
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 15.0,
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                width: 40, height: 40,
                child: const Icon(Icons.location_on, color: Color(0xFF059669), size: 35),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * UI : Message si aucune discussion.
   */
  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 40, color: Colors.grey[200]),
          const SizedBox(height: 12),
          const Text(
            "Aucun message pour le moment.\nDites bonjour à l'équipe HYSACAM !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /**
   * Construit l'en-tête avec les détails du signalement.
   */
  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.report.imageUrl,
                  width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60, height: 60, color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.report.title ?? widget.report.typeInsalubrite).toUpperCase(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "STATUS: ${widget.report.statut.toUpperCase()}",
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.report.description,
            style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
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
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isAdmin ? const Color(0xFFF1F5F9) : const Color(0xFF059669),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isAdmin ? 4 : 20),
                bottomRight: Radius.circular(isAdmin ? 20 : 4),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isAdmin ? const Color(0xFF1F2937) : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$sender • $time",
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  /**
   * Champ de saisie du message.
   */
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10)),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Écrire au support...",
                    hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
