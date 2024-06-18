class RendezVous {
  final String nomParent;
  final DateTime date;
  final String heureDebut;
  final String heureFin;

  RendezVous({
    required this.nomParent,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
  });

  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      nomParent: json['nomParent'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      heureDebut: json['heure_debut'] ?? '',
      heureFin: json['heure_fin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "nomParent": nomParent,
        "date": date.toIso8601String(),
        "heure_debut": heureDebut,
        "heure_fin": heureFin,
      };
}

class Localisation {
  final String? id;
  final String description;
  final double latitude;
  final double longitude;

  Localisation({
    this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "latitude": latitude,
      "longitude": longitude
    };
  }

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      id: json["id"],
      description: json["description"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}

class BabysitterModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String phone;
  final String description;
  final String accepte;
  final List<RendezVous> rendezVous;
  final String fcmToken;
  final Localisation? location;

  BabysitterModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.phone,
    required this.description,
    required this.accepte,
    required this.rendezVous,
    required this.fcmToken,
    this.location,
  });

  factory BabysitterModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> rendezVousJson = json['rendezVous'] ?? [];
    List<RendezVous> rendezVousList =
        rendezVousJson.map((rv) => RendezVous.fromJson(rv)).toList();

    return BabysitterModel(
        id: json['_id'] ?? '',
        nom: json['nom'] ?? '',
        prenom: json['prenom'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        phone: json['phone'] ?? '',
        description: json['description'] ?? '',
        accepte: json['accepte'] ?? '',
        fcmToken: json['fcmToken'] ?? "",
        rendezVous: rendezVousList,
        location: json["location"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "password": password,
        "phone": phone,
        "description": description,
        "accepte": accepte,
        "fcmToken": fcmToken,
        "rendezVous": rendezVous.map((rv) => rv.toJson()).toList(),
        "location": location!.toJson()
      };
}
