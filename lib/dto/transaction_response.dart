class TransactionDTOResponse {
  final int id;
  final double montantEnvoye;
  final double montantRecus;
  final EtatTransactionEnum etatTransaction;
  final TypeTransactionEnum typeTransaction;
  final String? senderName;
  final String? receiverName;
  final int senderId;
  final int receiverId;
  final double? fraisValeur;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TransactionDTOResponse({
    required this.id,
    required this.montantEnvoye,
    required this.montantRecus,
    required this.etatTransaction,
    required this.typeTransaction,
    this.senderName,
    this.receiverName,
    required this.senderId,
    required this.receiverId,
    this.fraisValeur,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert JSON to TransactionDTOResponse
  factory TransactionDTOResponse.fromJson(Map<String, dynamic> json) {
    return TransactionDTOResponse(
      id: json['id'],
      montantEnvoye: json['montantEnvoye'],
      montantRecus: json['montantRecus'],
      etatTransaction: _parseEtatTransaction(json['etatTransaction']),
      typeTransaction: _parseTypeTransaction(json['typeTransaction']),
      senderName: json['senderName'] ?? '',
      receiverName: json['receiverName'] ?? '',
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      fraisValeur: json['fraisValeur'] != null ? json['fraisValeur'] : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  static EtatTransactionEnum _parseEtatTransaction(String? value) {
    return EtatTransactionEnum.values.firstWhere(
      (e) => e.toString() == 'EtatTransactionEnum.$value',
      orElse: () =>
          EtatTransactionEnum.EFFECTUE, // default value or handle error
    );
  }

  static TypeTransactionEnum _parseTypeTransaction(String? value) {
    return TypeTransactionEnum.values.firstWhere(
      (e) => e.toString() == 'TypeTransactionEnum.$value',
      orElse: () =>
          TypeTransactionEnum.TRANSFERT, // default value or handle error
    );
  }

  // Convert TransactionDTOResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montantEnvoye': montantEnvoye,
      'montantRecus': montantRecus,
      'etatTransaction': etatTransaction.toString().split('.').last,
      'typeTransaction': typeTransaction.toString().split('.').last,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderId': senderId,
      'receiverId': receiverId,
      'fraisValeur': fraisValeur,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

enum EtatTransactionEnum {
  EFFECTUE,
  ANNULER,
}

enum TypeTransactionEnum {
  TRANSFERT,
}
