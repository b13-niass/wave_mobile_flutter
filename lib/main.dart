import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/providers/solde_provider.dart';
import 'package:wave_mobile_flutter/ui/wave_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SoldeProvider()),
    ], child: WaveApp()),
  );
}
