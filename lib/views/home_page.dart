import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controlers/home_controller.dart';
import '../models/report_model.dart';
import 'report_details_page.dart';
import 'notifications_page.dart';

/**
 * HomePage - Écran principal du Tableau de Bord Citoyen.
 * 
 * Présente un résumé de l'impact de l'utilisateur (Eco-Points, Impact CO2)
 * et un flux des signalements récents dans la ville de Douala.
 * Le design suit la charte "Simple & Beau" avec les couleurs HYSACAM.
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  List<ReportModel> _allReports = [];
  String _selectedFilter = "TOUT"; // TOUT, MOI, RÉSOLU
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /**
   * Récupère les données réelles au démarrage ou via refresh.
   */
  Future<void> _loadData() async {
    await _controller.fetchUserStats(); // Pour les points et stats
    final data = await _controller.fetchAllCommunityReports(); // Flux global
    if (mounted) {
      setState(() {
        _allReports = data;
        _isLoading = false;
      });
    }
  }

  /**
   * Filtre la liste des rapports selon le choix de l'utilisateur.
   */
  List<ReportModel> _getFilteredReports() {
    if (_selectedFilter == "TOUT") return _allReports;
    if (_selectedFilter == "MOI") {
      final user = Supabase.instance.client.auth.currentUser;
      return _allReports.where((r) => r.userId == user?.id).toList(); 
    }
    if (_selectedFilter == "RÉSOLU") {
      return _allReports.where((r) => r.statut.toLowerCase() == "résolu").toList();
    }
    return _allReports;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final filteredReports = _getFilteredReports();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF059669),
        child: CustomScrollView(
          slivers: [
            /** Section En-tête Dynamique */
            SliverToBoxAdapter(child: _buildHeader(user, isDark)),
            
            /** Section Statistiques d'Impact (Carte Flottante) */
            SliverToBoxAdapter(child: _buildImpactCard(_controller, isDark)),
            
            /** Section Filtres Communautaires */
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("TOUT", Icons.all_inclusive_rounded, isDark),
                      _buildFilterChip("MOI", Icons.person_pin_rounded, isDark),
                      _buildFilterChip("RÉSOLU", Icons.check_circle_outline_rounded, isDark),
                    ],
                  ),
                ),
              ),
            ),
            
            /** Titre de la section Signalements */
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedFilter == "MOI" ? "MES SIGNALEMENTS" : "FLUX DE DOUALA",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const Icon(Icons.tune, size: 20, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
            
            /** Liste des signalements récents ou Indicateur de chargement */
            _isLoading 
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF059669))),
                )
              : filteredReports.isEmpty 
                ? const SliverFillRemaining(
                    child: Center(child: Text("Aucun signalement trouvé", style: TextStyle(color: Colors.grey))),
                  )
                : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailsPage(report: filteredReports[index]),
                          ),
                        );
                      },
                      child: _buildReportCard(filteredReports[index], isDark),
                    );
                  },
                  childCount: filteredReports.length,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  /** UI : Chip de filtre personnalisé HYSACAM */
  Widget _buildFilterChip(String label, IconData icon, bool isDark) {
    final isSelected = _selectedFilter == label;
    // La couleur de fond non-sélectionnée s'adapte au mode sombre
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    // Si c'est sélectionné, l'intérieur est vert (clair) avec un texte blanc. Sauf si on force.
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ChoiceChip(
        avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF059669)),
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: isSelected ? Colors.white : const Color(0xFF059669),
        ),
        selected: isSelected,
        onSelected: (val) => setState(() => _selectedFilter = label),
        backgroundColor: bgColor,
        selectedColor: const Color(0xFF059669),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: isSelected ? Colors.transparent : (isDark ? Colors.grey[800]! : const Color(0xFFE2E8F0))),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  /**
   * Construit l'en-tête de la page avec les infos utilisateur.
   */
  Widget _buildHeader(User? user, bool isDark) {
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
              /** Avatar Utilisateur (Icône universelle) */
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Icon(Icons.person_outline_rounded, color: Color(0xFF059669), size: 30),
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
          /** Notification Badge (Vers Alertes) */
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Construit la carte d'impact citoyen (Eco-Points / KG CO2).
   */
  Widget _buildImpactCard(HomeController controller, bool isDark) {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
          border: Border.all(color: isDark ? Colors.grey[800]! : const Color(0xFFF1F5F9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImpactItem("Points", controller.getEcoPoints().toString(), Icons.emoji_events_outlined, const Color(0xFFFBBF24), isDark),
            Container(width: 1, height: 40, color: isDark ? Colors.grey[800] : const Color(0xFFF1F5F9)),
            _buildImpactItem("Impact", "${controller.getCo2Impact()} Kg", Icons.eco_outlined, const Color(0xFF059669), isDark),
          ],
        ),
      ),
    );
  }

  /**
   * Élément individuel d'impact (icône + libellé).
   */
  Widget _buildImpactItem(String label, String value, IconData icon, Color color, bool isDark) {
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
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF1F2937))),
      ],
    );
  }

  /**
   * Construit une carte stylisée pour un signalement.
   */
  Widget _buildReportCard(ReportModel report, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isDark ? Colors.grey[800]! : const Color(0xFFF1F5F9)),
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
                  (report.title ?? report.typeInsalubrite).toUpperCase(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF1F2937)),
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
