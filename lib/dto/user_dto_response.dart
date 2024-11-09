import 'package:wave_mobile_flutter/dto/wallet_dto_response.dart';
import 'transaction_dto_response.dart';

enum EtatCompteEnum { ACTIF, INACTIF }

enum ChannelEnum { SMS, EMAIL }

enum RoleEnum { CLIENT, DISTRIBUTEUR, ADMIN }

class UserDTOResponse {
  final int? id;
  final String? nom;
  final String? prenom;
  final String? adresse;
  final String? telephone;
  final String? email;
  final EtatCompteEnum? etatCompte;
  final ChannelEnum? channel;
  final RoleEnum? role;
  final String? paysLibelle;
  final WalletDTOResponse? wallet;
  final int? nbrConnection;
  final List<TransactionDTOResponse>? transactions;

  UserDTOResponse({
    this.id,
    this.nom,
    this.prenom,
    this.adresse,
    this.telephone,
    this.email,
    this.etatCompte,
    this.channel,
    this.role,
    this.paysLibelle,
    this.wallet,
    this.nbrConnection,
    this.transactions,
  });

  factory UserDTOResponse.fromJson(Map<String, dynamic> json) {
    return UserDTOResponse(
      id: json['id'] != null ? json['id'] as int : 0,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      adresse: json['adresse'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      etatCompte: json['etatCompte'] != null
          ? EtatCompteEnum.values.byName(json['etatCompte'])
          : null,
      channel: json['channel'] != null
          ? ChannelEnum.values.byName(json['channel'])
          : null,
      role: json['role'] != null ? RoleEnum.values.byName(json['role']) : null,
      paysLibelle: json['paysLibelle'] as String?,
      wallet: json['wallet'] != null
          ? WalletDTOResponse.fromJson(json['wallet'])
          : null,
      nbrConnection:
          json['nbrConnection'] != null ? json['nbrConnection'] as int : 0,
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
              .map((e) => TransactionDTOResponse.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
      'etatCompte': etatCompte?.name,
      'channel': channel?.name,
      'role': role?.name,
      'paysLibelle': paysLibelle,
      'wallet': wallet?.toJson(),
      'nbrConnection': nbrConnection,
      'transactions': transactions?.map((e) => e.toJson()).toList(),
    };
  }
}
