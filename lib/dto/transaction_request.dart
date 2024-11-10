class TransactionRequest {
  final String telephone;
  final double montantEnvoye;
  final double montantRecus;

  TransactionRequest({
    required this.telephone,
    required this.montantEnvoye,
    required this.montantRecus,
  });

  factory TransactionRequest.fromJson(Map<String, dynamic> json) {
    return TransactionRequest(
      telephone: json['telephone'],
      montantEnvoye: json['montantEnvoye'],
      montantRecus: json['montantRecus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'montantEnvoye': montantEnvoye,
      'montantRecus': montantRecus
    };
  }
}
