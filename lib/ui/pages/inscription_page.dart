import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/api/index.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  static const primaryColor = Color(0xFF6C63FF);
  static const backgroundColor = Color(0xFFF5F6F9);
  static const textColor = Color(0xFF2D3142);

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: const Text(
                      'Inscription',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Email input field
                  InputField(
                    label: 'Email',
                    icon: Icons.email,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Telephone input field
                  InputField(
                    label: 'Telephone',
                    icon: Icons.phone,
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro de téléphone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Password input field (PIN style with 4 boxes)
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: primaryColor.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            style:
                                const TextStyle(fontSize: 24, color: textColor),
                            onChanged: (value) {
                              if (value.length == 1) {
                                if (index < 3) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[index + 1]);
                                } else {
                                  FocusScope.of(context).unfocus();
                                }
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inscription en cours...'),
                              backgroundColor: primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          String password =
                              _controllers.map((e) => e.text).join();
                          final String email = _emailController.text;
                          final String phone = "+221${_phoneController.text}";

                          dynamic result = await ApiFetch.registerClient(
                              email, phone, password);

                          if (result["status"] == "OK") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('compte créer avec succès!'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pushNamed(context, '/login');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result["message"]),
                                backgroundColor: Colors.red,
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
                        'S\'inscrire',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom InputField widget for reusability with validation
class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _RegistrationPageState.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon:
                  Icon(icon, color: _RegistrationPageState.primaryColor),
              labelText: label,
              labelStyle:
                  const TextStyle(color: _RegistrationPageState.primaryColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color:
                        _RegistrationPageState.primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: _RegistrationPageState.primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: label == 'Telephone'
                ? TextInputType.phone
                : TextInputType.emailAddress,
            style: const TextStyle(
                color: _RegistrationPageState.textColor, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
