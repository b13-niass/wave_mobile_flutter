enum EtatTransactionEnum { PENDING, COMPLETED, FAILED } // Replace with actual transaction enums
enum TypeTransactionEnum { SEND, RECEIVE } // Replace with actual transaction types

class TransactionDTOResponse {
  final int id;
  final double montantEnvoye;
  final double montantRecus;
  final EtatTransactionEnum etatTransaction;
  final TypeTransactionEnum typeTransaction;
  final String senderName;
  final String receiverName;
  final int senderId;
  final int receiverId;
  final double? fraisValeur;

  TransactionDTOResponse({
    required this.id,
    required this.montantEnvoye,
    required this.montantRecus,
    required this.etatTransaction,
    required this.typeTransaction,
    required this.senderName,
    required this.receiverName,
    required this.senderId,
    required this.receiverId,
    this.fraisValeur,
  });

  factory TransactionDTOResponse.fromJson(Map<String, dynamic> json) {
    return TransactionDTOResponse(
      id: json['id'],
      montantEnvoye: json['montantEnvoye'],
      montantRecus: json['montantRecus'],
      etatTransaction: EtatTransactionEnum.values.byName(json['etatTransaction']),
      typeTransaction: TypeTransactionEnum.values.byName(json['typeTransaction']),
      senderName: json['senderName'],
      receiverName: json['receiverName'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      fraisValeur: json['fraisValeur']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montantEnvoye': montantEnvoye,
      'montantRecus': montantRecus,
      'etatTransaction': etatTransaction.name,
      'typeTransaction': typeTransaction.name,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderId': senderId,
      'receiverId': receiverId,
      'fraisValeur': fraisValeur,
    };
  }
}
