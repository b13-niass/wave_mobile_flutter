import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/ui/wave_app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(WaveApp());
}
