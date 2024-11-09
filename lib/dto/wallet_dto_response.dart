class WalletDTOResponse {
  final int id;
  final double solde;
  final double plafond;
  final int userId;
  final String userNom;

  WalletDTOResponse({
    required this.id,
    required this.solde,
    required this.plafond,
    required this.userId,
    required this.userNom,
  });

  // Factory constructor for creating an instance from JSON
  factory WalletDTOResponse.fromJson(Map<String, dynamic> json) {
    return WalletDTOResponse(
      id: json['id'],
      solde: json['solde'],
      plafond: json['plafond'],
      userId: json['userId'],
      userNom: json['userNom'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solde': solde,
      'plafond': plafond,
      'userId': userId,
      'userNom': userNom,
    };
  }
}
