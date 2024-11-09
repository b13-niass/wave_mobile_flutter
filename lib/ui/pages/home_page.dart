import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:wave_mobile_flutter/api/client.dart';
import 'package:wave_mobile_flutter/config/contact_sync_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryColor = const Color(0xFF4B45B2);
  final Color cardBlue = const Color(0xFF38B6FF);

  String? base64Image;
  Map<String, dynamic>? _clientData;
  bool _isHidden = false;

  final ContactSyncService contactSyncService = ContactSyncService();

  @override
  void initState() {
    super.initState();
    _initializeContacts();
    _fetchClientData();
  }

  Future<void> _initializeContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool contactsSynced = prefs.getBool('contactsSynced') ?? false;

    if (!contactsSynced) {
      // Demander à l'utilisateur s'il souhaite importer les contacts
      bool? shouldSync = await _showImportContactsDialog();
      if (shouldSync == true) {
        await contactSyncService.syncContactsFromDevice();
        await prefs.setBool('contactsSynced', true);
      }
    }
  }

  Future<bool?> _showImportContactsDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Importer les contacts"),
        content:
            Text("Voulez-vous importer les contacts de votre répertoire ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Non"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Oui"),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchClientData() async {
    try {
      final data = await ClientFetch.accueilClient();
      setState(() {
        _clientData = data["data"]["user"];
        base64Image = data["data"]["qrCode"];
      });
    } catch (e) {
      print('Erreur lors de la récupération des données client : $e');
    }
  }

  String formatDateToFrench(String dateString) {
    Intl.defaultLocale = 'fr_FR';
    DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat("MMMM d, y 'à' HH:mm", 'fr_FR');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.settings, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isHidden)
                    ...List.generate(
                      8,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  else
                    const Text(
                      '10,000 Fcfa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _isHidden
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isHidden = !_isHidden;
                      });
                    },
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/qrscanner');
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cardBlue,
                        cardBlue.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.white.withOpacity(0.3),
                    onTap: () {},
                    child: Column(
                      children: [
                        base64Image != null
                            ? Image.memory(
                                base64Decode(base64Image!),
                                width: 120,
                                height: 120,
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Scanner',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildActionButton('Transfert', Icons.person),
                    const SizedBox(width: 24),
                    _buildActionButton('Planifier', Icons.shopping_basket),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 400,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: (_clientData?["transactions"] ?? []).isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: (_clientData?["transactions"] ?? []).length,
                        itemBuilder: (context, index) {
                          final transaction =
                              _clientData?["transactions"]![index];
                          final title = transaction["typeTransaction"];
                          final date = formatDateToFrench(
                              transaction["createdAt"].toString());
                          final amount = title == "TRANSFERT"
                              ? transaction["montantEnvoye"].toString()
                              : "'-'${transaction["montantEnvoye"].toString()}";
                          return _buildTransaction(title, date, amount);
                        },
                      )
                    : const Center(
                        child: Text('No transactions available.'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == 'Transfert') {
          Navigator.pushNamed(context, '/contactselection');
        } else if (label == 'Planifier') {
          Navigator.pushNamed(context, '/schedule');
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction(String title, String date, String amount) {
    final bool isNegative = amount.startsWith('-');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: isNegative ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
