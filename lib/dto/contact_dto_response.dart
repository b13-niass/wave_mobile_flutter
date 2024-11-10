class Contact {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  bool isFavorite;

  Contact({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.isFavorite = false,
  });

  // Convert from database Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      telephone: map['telephone'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  // Convert to database Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}
