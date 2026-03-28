class UserModel {
  final String id;
  final String nom;
  final String email;
  final String role; // Citoyen, Autorité, etc.

  UserModel({
    required this.id,
    required this.nom,
    required this.email,
    required this.role,
  });

  // Pour transformer les données venant d'une base de données (JSON) en objet
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      role: json['role'],
    );
  }
}
