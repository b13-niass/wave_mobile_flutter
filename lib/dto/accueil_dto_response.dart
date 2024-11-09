import 'user_dto_response.dart';

class AccueilDTOResponse {
  final String qrCode;
  final UserDTOResponse user;

  AccueilDTOResponse({
    required this.qrCode,
    required this.user,
  });

  factory AccueilDTOResponse.fromJson(Map<String, dynamic> json) {
    return AccueilDTOResponse(
      qrCode: json['qrCode'],
      user: UserDTOResponse.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrCode': qrCode,
      'user': user.toJson(),
    };
  }
}
