// routes.dart
import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/ui/pages/codesecret_page.dart';
import 'package:wave_mobile_flutter/ui/pages/contact_selection.dart';
import 'package:wave_mobile_flutter/ui/pages/home_page.dart';
import 'package:wave_mobile_flutter/ui/pages/inscription_page.dart';
import 'package:wave_mobile_flutter/ui/pages/login_page.dart';
import 'package:wave_mobile_flutter/ui/pages/qrscanner_page.dart';
import 'package:wave_mobile_flutter/ui/pages/transfert_contact_page.dart';
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
        return MaterialPageRoute(builder: (_) => CodesecretPage());
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
          builder: (_) => ContactSelectionPage(),
        );
      case transfertcontact:
        return MaterialPageRoute(
          builder: (_) => TransferContactPage(
            name: 'Prénom Nom',
            phoneNumber: '77 888 88 88',
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
