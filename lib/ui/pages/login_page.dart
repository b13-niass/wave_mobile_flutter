import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/api/index.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final primaryColor = const Color(0xFF6C63FF);
  final backgroundColor = const Color(0xFFF5F6F9);
  final textColor = const Color(0xFF2D3142);

  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  // Country code options and selected value
  final List<String> _countryCodes = ['+221', '+223'];
  String _selectedCountryCode = '+221';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bienvenue sur notre application',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Phone input field with country code selector
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Country code dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: primaryColor.withOpacity(0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountryCode,
                              items: _countryCodes
                                  .map((code) => DropdownMenuItem(
                                        value: code,
                                        child: Text(
                                          code,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountryCode = value!;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down,
                                  color: primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Phone number input field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Numéro de téléphone',
                                labelStyle: TextStyle(color: primaryColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: primaryColor, width: 2),
                                ),
                                prefixIcon:
                                    Icon(Icons.phone, color: primaryColor),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: textColor, fontSize: 16),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un numéro de téléphone';
                                } else if (value.length < 9) {
                                  return 'Le numéro de téléphone doit contenir au moins 9 chiffres';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Connexion en cours...'),
                              backgroundColor: primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          final String telephone =
                              _selectedCountryCode + _phoneController.text;
                          print(telephone);
                          dynamic result =
                              await ApiFetch.findClientByTelephone(telephone);
                          print(result);
                          if (result["status"] == "OK") {
                            Navigator.pushNamed(context, '/verification');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result["message"]),
                                backgroundColor: Color.fromRGBO(255, 0, 0, 0.5),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: primaryColor.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Suivant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Help text
                  Center(
                      child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context,
                          '/inscription'); // Replace with your route name
                    },
                    child: Text(
                      "S'inscrire ici",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
