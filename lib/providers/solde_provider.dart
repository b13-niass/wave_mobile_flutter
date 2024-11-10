import 'package:flutter/material.dart';

class SoldeProvider with ChangeNotifier {
  double _solde = 0;

  double get solde => _solde;

  void changeSolde(double amount) {
    _solde = amount;
    notifyListeners();
  }
}
