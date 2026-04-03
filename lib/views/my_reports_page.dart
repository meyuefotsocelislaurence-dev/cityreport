import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';
import 'report_details_page.dart';

/**
 * MyReportsPage - Historique personnel des signalements.
 * 
 * Affiche l'historique complet des signalements créés par l'utilisateur connecté.
 */
class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  final supabase = Supabase.instance.client;
  List<ReportModel> _myReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMyReports();
  }

  Future<void> _fetchMyReports() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final response = await supabase
          .from('reports')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _myReports = (response as List)
              .map((json) => ReportModel.fromMap(json))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur MyReports: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MES SIGNALEMENTS",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF1F2937),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF059669)))
          : _myReports.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: const Color(0xFF059669),
                  onRefresh: _fetchMyReports,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    itemCount: _myReports.length,
                    itemBuilder: (context, index) {
                      final report = _myReports[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetailsPage(report: report),
                            ),
                          );
                        },
                        child: _buildReportCard(report),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            "Vous n'avez aucun signalement pour le moment.",
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    // Style adaptatif suivant le mode (thème gère la couleur de Dialog/Card)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBadge(report.statut),
                const SizedBox(height: 8),
                Text(
                  (report.title ?? report.typeInsalubrite).toUpperCase(),
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w900, 
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      "Quartier de Douala",
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
