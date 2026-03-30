import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controlers/home_controller.dart';
import '../models/report_model.dart';
import 'report_details_page.dart';

/**
 * HomePage - Écran principal du Tableau de Bord Citoyen.
 * 
 * Présente un résumé de l'impact de l'utilisateur (Eco-Points, Impact CO2)
 * et un flux des signalements récents dans la ville de Douala.
 * Le design suit la charte "Simple & Beau" avec les couleurs HYSACAM.
 */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /** Initialisation du contrôleur et récupération des données */
    final HomeController controller = HomeController();
    final List<ReportModel> reports = controller.getRecentReports();
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Fond gris très clair
      body: CustomScrollView(
        slivers: [
          /** Section En-tête Dynamique */
          SliverToBoxAdapter(
            child: _buildHeader(user),
          ),
          
          /** Section Statistiques d'Impact (Carte Flottante) */
          SliverToBoxAdapter(
            child: _buildImpactCard(controller),
          ),
          
          /** Titre de la section Signalements */
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MES SIGNALEMENTS",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 2.0,
                    ),
                  ),
                  Icon(Icons.tune, size: 20, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
          
          /** Liste des signalements récents */
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportDetailsPage(report: reports[index]),
                        ),
                      );
                    },
                    child: _buildReportCard(reports[index]),
                  );
                },
                childCount: reports.length,
              ),
            ),
          ),
          
          /** Espace de fin pour la barre de navigation */
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  /**
   * Construit l'en-tête de la page avec les infos utilisateur.
   */
  Widget _buildHeader(User? user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
      decoration: const BoxDecoration(
        color: Color(0xFF059669), // Vert HYSACAM
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              /** Avatar Utilisateur */
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage("https://ui-avatars.com/api/?name=Jean+Douala&background=FBBF24&color=059669&size=100"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              /** Salutations */
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bonjour,",
                    style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email?.split('@')[0].toUpperCase() ?? "JEAN DOUALA",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          /** Notification Badge */
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /**
   * Construit la carte d'impact citoyen (Eco-Points / KG CO2).
   */
  Widget _buildImpactCard(HomeController controller) {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImpactItem("Points", controller.getEcoPoints().toString(), Icons.emoji_events_outlined, const Color(0xFFFBBF24)),
            Container(width: 1, height: 40, color: const Color(0xFFF1F5F9)),
            _buildImpactItem("Impact", "${controller.getCo2Impact()} Kg", Icons.eco_outlined, const Color(0xFF059669)),
          ],
        ),
      ),
    );
  }

  /**
   * Élément individuel d'impact (icône + libellé).
   */
  Widget _buildImpactItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8))),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
      ],
    );
  }

  /**
   * Construit une carte stylisée pour un signalement.
   */
  Widget _buildReportCard(ReportModel report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          /** Image du signalement */
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              report.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80, height: 80, color: Colors.grey[200],
                child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          /** Infos Rapport */
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBadge(report.statut),
                const SizedBox(height: 8),
                Text(
                  report.typeInsalubrite.toUpperCase(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      "QUARTIER AKWA", // On pourrait ajouter des localisations réelles
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Badge de statut épuré (Ambre pour En attente, Vert pour le reste).
   */
  Widget _buildStatusBadge(String status) {
    final isPending = status == "En attente";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: isPending ? const Color(0xFF92400E) : const Color(0xFF166534),
        ),
      ),
    );
  }
}
