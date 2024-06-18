class ParentModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String phone;
  final int nbEnfants;

  ParentModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.phone,
    required this.nbEnfants,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      nbEnfants: json['nombreDesEnfants'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "password": password,
        "phone": phone,
        "nombreDesEnfants,": nbEnfants,
      };
}
