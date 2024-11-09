import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void dispose() {
    _sentAmountController.dispose();
    _receivedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Transfert de Contact'),
        titleTextStyle: TextStyle(
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
                // Contact information header
                Card(
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
                ),
                const SizedBox(height: 24),

                // Field for sent amount
                _buildAmountField(
                  controller: _sentAmountController,
                  labelText: 'Montant Envoyé',
                ),
                const SizedBox(height: 16),

                // Field for received amount
                _buildAmountField(
                  controller: _receivedAmountController,
                  labelText: 'Montant Reçu',
                ),

                // Flexible space to push the button to the bottom
                const Spacer(),

                // Send button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Transfer handling logic
                      print('Montant envoyé: ${_sentAmountController.text}');
                      print('Montant reçu: ${_receivedAmountController.text}');
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable amount input field with consistent styling
  Widget _buildAmountField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextFormField(
      controller: controller,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un montant';
        }
        return null;
      },
      style: const TextStyle(color: textColor, fontSize: 16),
    );
  }
}
