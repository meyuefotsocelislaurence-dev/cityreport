import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';
import 'package:flutter/material.dart';

/**
 * MapController - Gestionnaire de la logique cartographique dynamique.
 * 
 * Responsable de la récupération des signalements réels depuis Supabase 
 * et de la génération des marqueurs interactifs pour la carte.
 */
class MapController {
  final supabase = Supabase.instance.client;
  List<ReportModel> reports = [];

  /**
   * Récupère tous les signalements réels depuis la base de données.
   */
  Future<List<ReportModel>> fetchReports() async {
    try {
      final response = await supabase
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      reports = (response as List)
          .map((json) => ReportModel.fromMap(json))
          .toList();
      
      return reports;
    } catch (e) {
      print('Erreur de récupération des signalements: $e');
      return [];
    }
  }

  /**
   * Génère les widgets de marqueurs pour la carte OSM.
   * Chaque marqueur est cliquable pour afficher les détails du signalement.
   */
  List<Marker> getMarkers(List<ReportModel> data, Function(ReportModel) onTap) {
    return data.map((report) {
      return Marker(
        point: LatLng(report.latitude, report.longitude),
        width: 45,
        height: 45,
        child: GestureDetector(
          onTap: () => onTap(report),
          child: Container(
            decoration: BoxDecoration(
              color: _getStatusColor(report.statut),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              _getStatusIcon(report.statut),
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  /** Retourne la couleur selon le statut du signalement */
  Color _getStatusColor(String statut) {
    switch (statut.toLowerCase()) {
      case "résolu": return const Color(0xFF059669); // Vert
      case "en cours": return const Color(0xFF3B82F6); // Bleu
      default: return const Color(0xFFFBBF24); // Orange/Jaune (En attente)
    }
  }

  /** Retourne l'icône selon le statut du signalement */
  IconData _getStatusIcon(String statut) {
    switch (statut.toLowerCase()) {
      case "résolu": return Icons.check_rounded;
      case "en cours": return Icons.engineering_rounded;
      default: return Icons.report_problem_outlined;
    }
  }
}