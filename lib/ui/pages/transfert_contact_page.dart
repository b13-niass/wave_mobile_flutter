import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wave_mobile_flutter/api/client.dart';
import 'package:wave_mobile_flutter/dto/transaction_request.dart';
import 'package:wave_mobile_flutter/providers/solde_provider.dart';

class TransferContactPage extends StatefulWidget {
  final String name;
  final String phoneNumber;

  const TransferContactPage({
    super.key,
    required this.name,
    required this.phoneNumber,
  });

  @override
  State<TransferContactPage> createState() => _TransferContactPageState();
}

class _TransferContactPageState extends State<TransferContactPage> {
  static const primaryColor = Color(0xFF4749D5);
  static const backgroundColor = Color(0xFFF5F6F9);
  static const textColor = Color(0xFF2D3142);

  final _formKey = GlobalKey<FormState>();
  final _sentAmountController = TextEditingController();
  final _receivedAmountController = TextEditingController();

  double? solde;

  @override
  void initState() {
    super.initState();
    solde = Provider.of<SoldeProvider>(context, listen: false).solde;
    _sentAmountController.addListener(_calculateReceivedAmount);
  }

  @override
  void dispose() {
    _sentAmountController.removeListener(_calculateReceivedAmount);
    _sentAmountController.dispose();
    _receivedAmountController.dispose();
    super.dispose();
  }

  void _calculateReceivedAmount() {
    if (_sentAmountController.text.isNotEmpty) {
      double montantEnvoye = double.tryParse(_sentAmountController.text) ?? 0;
      _receivedAmountController.text =
          (montantEnvoye * 0.95).toStringAsFixed(2); // Exemple: 5% de frais
    } else {
      _receivedAmountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Transfert de Contact'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildContactInfo(),
                const SizedBox(height: 24),
                _buildAmountField(
                  controller: _sentAmountController,
                  labelText: 'Montant Envoyé',
                  isEnabled: true,
                  validator: (value) {
                    double montant = double.tryParse(value ?? '') ?? 0;
                    if (montant <= 0 || montant > (solde ?? 0)) {
                      return 'Montant doit être ≤ $solde';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildAmountField(
                  controller: _receivedAmountController,
                  labelText: 'Montant Reçu',
                  isEnabled: false,
                ),
                const Spacer(),
                _buildSendButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.phoneNumber,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String labelText,
    required bool isEnabled,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator,
      style: const TextStyle(color: textColor, fontSize: 16),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transfert en cours...'),
              backgroundColor: primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );

          List<TransactionRequest> transferts = [
            TransactionRequest(
              telephone: "+221${widget.phoneNumber}",
              montantEnvoye: double.parse(_sentAmountController.text),
              montantRecus: double.parse(_receivedAmountController.text),
            ),
          ];

          dynamic result = await ClientFetch.transfertsClient(transferts);

          if (result["status"] == "OK") {
            Navigator.pushNamed(context, '/home');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result["message"]),
                backgroundColor: primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result["message"]),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Envoyer',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
