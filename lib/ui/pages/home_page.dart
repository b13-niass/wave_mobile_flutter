import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wave_mobile_flutter/api/client.dart';
import 'package:wave_mobile_flutter/api/token_storage.dart';
import 'package:wave_mobile_flutter/config/contact_sync_service.dart';
import 'package:wave_mobile_flutter/dto/transaction_response.dart';
import 'package:wave_mobile_flutter/providers/solde_provider.dart';
import 'package:wave_mobile_flutter/ui/pages/login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryColor = const Color(0xFF4B45B2);
  final Color cardBlue = const Color(0xFF38B6FF);

  String? base64Image;
  double solde = 0;
  Map<String, dynamic>? _clientData;
  bool _isHidden = false;
  bool _isLoading = true;

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
      Provider.of<SoldeProvider>(context, listen: false)
          .changeSolde(data["data"]["user"]["wallet"]["solde"]);
    } catch (e) {
      print('Erreur lors de la récupération des données client : $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            TokenStorage.logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          },
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
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
                          Text(
                            double.parse(_clientData!["wallet"]["solde"]
                                        .toString())
                                    .round()
                                    .toString() +
                                ' Fcfa',
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
                      onTap: () {},
                      child: SizedBox(
                        // Ajoutez ceci
                        width: 300, // Ajustez cette valeur selon vos besoins
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
                          child: Column(
                            children: [
                              const SizedBox(height: 4),
                              base64Image != null
                                  ? Image.memory(
                                      base64Decode(base64Image!),
                                      width: 120,
                                      height: 120,
                                    )
                                  : Container(),
                              const SizedBox(height: 4),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 2),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton('Transfert', Icons.person),
                          const SizedBox(width: 24),
                          _buildActionButton('Scanner', Icons.qr_code_scanner),
                        ],
                      ),
                    ),
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
                              itemCount:
                                  (_clientData?["transactions"] ?? []).length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    _clientData?["transactions"]![index];
                                final title = transaction["typeTransaction"];
                                final date = formatDateToFrench(
                                    transaction["createdAt"].toString());
                                final amount = title == "TRANSFERT"
                                    ? "-${transaction["montantEnvoye"].toString()}"
                                    : transaction["montantEnvoye"].toString();
                                return _buildTransaction(
                                    title, date, amount, transaction);
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
        } else if (label == 'Scanner') {
          Navigator.pushNamed(context, '/qrscanner');
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
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

  Widget _buildTransaction(
      String title, String date, String amount, dynamic transaction) {
    final bool isNegative = amount.startsWith('-');
    return InkWell(
      onTap: () {
        final transactionDTO = TransactionDTOResponse.fromJson(transaction);
        print(transactionDTO);
        Navigator.pushNamed(context, '/transfertdetail', arguments: {
          'transaction': transactionDTO,
        });
      },
      child: Padding(
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
      ),
    );
  }
}
