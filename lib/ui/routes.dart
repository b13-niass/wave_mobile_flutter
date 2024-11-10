// routes.dart
import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/dto/transaction_response.dart';
import 'package:wave_mobile_flutter/ui/pages/codesecret_page.dart';
import 'package:wave_mobile_flutter/ui/pages/contact_selection.dart';
import 'package:wave_mobile_flutter/ui/pages/home_page.dart';
import 'package:wave_mobile_flutter/ui/pages/inscription_page.dart';
import 'package:wave_mobile_flutter/ui/pages/login_page.dart';
import 'package:wave_mobile_flutter/ui/pages/qrscanner_page.dart';
import 'package:wave_mobile_flutter/ui/pages/transaction_detail_page.dart';
import 'package:wave_mobile_flutter/ui/pages/transfert_contact_page.dart';
import 'package:wave_mobile_flutter/ui/pages/transfert_multiple_page.dart';
import 'package:wave_mobile_flutter/ui/pages/verification_page.dart';

class AppRoutes {
  // Define route names
  static const String login = '/';
  static const String verification = '/verification';
  static const String inscription = '/inscription';
  static const String codesecret = '/codesecret';
  static const String home = '/home';
  static const String qrscanner = '/qrscanner';
  static const String contactselection = '/contactselection';
  static const String transfertcontact = '/transfertcontact';
  static const String transfertmultiple = '/transfertmultiple';
  static const String transfertdetail = '/transfertdetail';

  // Route generator function
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case verification:
        return MaterialPageRoute(builder: (_) => VerificationPage());
      case inscription:
        return MaterialPageRoute(builder: (_) => RegistrationPage());
      case codesecret:
        final args = settings.arguments as Map<String, dynamic>?;

        final telephone = args?['telephone'] ?? 'Telephone vide';

        return MaterialPageRoute(
            builder: (_) => CodesecretPage(telephone: telephone));
      case home:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case qrscanner:
        return MaterialPageRoute(
          builder: (_) => QRViewExample(),
        );
      case contactselection:
        return MaterialPageRoute(
          builder: (_) =>
              ContactSelectionPage(), // Extract data from arguments with fallback values
        );
      case transfertcontact:
        final args = settings.arguments as Map<String, dynamic>?;

        final name = args?['name'] ?? 'Prénom Nom';
        final phoneNumber = args?['phoneNumber'] ?? 'Telephone vide';

        return MaterialPageRoute(
          builder: (_) => TransferContactPage(
            name: name,
            phoneNumber: phoneNumber,
          ),
        );
      case transfertmultiple:
        final args = settings.arguments as Map<String, dynamic>?;

        final contacts = args?['contacts'] ?? [];

        return MaterialPageRoute(
          builder: (_) => TransferMultipleContactsPage(
            selectedContacts: contacts,
          ),
        );
      case transfertdetail:
        final args = settings.arguments as Map;

        // Cast args['transaction'] to TransactionDTOResponse
        final transaction = args['transaction'] as TransactionDTOResponse;

        return MaterialPageRoute(
          builder: (_) => TransactionDetailsPage(
            transaction: transaction,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
