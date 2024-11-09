import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/ui/routes.dart';

class WaveApp extends StatelessWidget {
  const WaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Connexion',
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
