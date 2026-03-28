import 'package:flutter/material.dart';
import '../controlers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CityReport",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _authController.emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(IconData(0xe22a, fontFamily: 'MaterialIcons')),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _authController.passwordController,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
                prefixIcon: Icon(IconData(0xe3ae, fontFamily: 'MaterialIcons')),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _authController.login(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Se connecter", style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: const Text("Pas encore de compte ? S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}