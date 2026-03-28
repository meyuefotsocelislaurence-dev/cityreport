import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("À propos"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo de l'application (Simulé par une icône)
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Icon(Icons.location_city, size: 70, color: Colors.white),
            ),
            const SizedBox(height: 15),
            const Text(
              "CityReport",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            // Description du projet
            const Text(
              "Notre Mission",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "CityReport est une application citoyenne conçue pour lutter contre l'insalubrité urbaine. Elle permet aux habitants de signaler en temps réel les dépôts d'ordures, les fuites d'eaux usées et les décharges sauvages afin de faciliter l'intervention des services municipaux.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            
            const SizedBox(height: 40),
            const Divider(),
            
            // Section Développeur
            const ListTile(
              leading: Icon(Icons.code, color: Colors.green),
              title: Text("Développeur"),
              subtitle: Text("Étudiant en Génie Logiciel"),
            ),
            const ListTile(
              leading: Icon(Icons.school, color: Colors.green),
              title: Text("Institution"),
              subtitle: Text("Projet de fin d'études / Soutenance 2026"),
            ),
            const ListTile(
              leading: Icon(Icons.contact_support, color: Colors.green),
              title: Text("Contact Support"),
              subtitle: Text("support@cityreport.cm"),
            ),
            
            const SizedBox(height: 40),
            const Text(
              "© 2026 CityReport - Tous droits réservés",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}