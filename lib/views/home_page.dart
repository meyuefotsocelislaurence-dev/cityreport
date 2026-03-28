import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controlers/home_controller.dart';
import '../models/report_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController _controller = HomeController();
    final List<ReportModel> reports = _controller.getRecentReports();
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            width: double.infinity,
            child: Text(
              user != null
                  ? 'Connecté en tant que ${user.email ?? 'utilisateur inconnu'}'
                  : 'Aucune session active',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Statistiques
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatCard(
                  "Total",
                  _controller.getTotalReports().toString(),
                  Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  "Résolus",
                  _controller.getResolvedReports().toString(),
                  Colors.green,
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Signalements récents",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Liste des signalements
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    title: Text(report.typeInsalubrite),
                    subtitle: Text(report.description),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: report.statut == "En cours"
                            ? Colors.blue[100]
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        report.statut,
                        style: TextStyle(
                          fontSize: 12,
                          color: report.statut == "En cours"
                              ? Colors.blue
                              : Colors.orange[800],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget utilitaire pour les cartes de stats
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
