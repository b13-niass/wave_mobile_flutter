import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wave_mobile_flutter/api/index.dart';

class CodesecretPage extends StatefulWidget {
  CodesecretPage({super.key});

  @override
  _CodesecretPageState createState() => _CodesecretPageState();
}

class _CodesecretPageState extends State<CodesecretPage> {
  static const primaryColor = Color(0xFF6C63FF);
  static const backgroundColor = Color(0xFFF5F6F9);
  static const textColor = Color(0xFF2D3142);

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  // Animated header for "Entrer le mot de passe"
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
                      'Entrer le mot de passe',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Verification code input fields (PIN style with 4 boxes)
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
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) {
                            if (event is RawKeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.backspace &&
                                _controllers[index].text.isEmpty &&
                                index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index - 1]);
                            }
                          },
                          child: TextFormField(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''; // No error text for clean layout
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.length == 1) {
                                if (index < 3) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[index + 1]);
                                } else {
                                  FocusScope.of(context)
                                      .unfocus(); // Dismiss keyboard when all fields are filled
                                }
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vérification en cours...'),
                              backgroundColor: primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          // Collect entered PIN code
                          String password = _controllers.map((e) => e.text).join();

                          dynamic result = await ApiFetch.login("+221767819339",password);

                          if (result["status"] == "OK") {
                            Navigator.pushNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result["message"]),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } else {
                          // Show error message if fields are empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez remplir tous les champs'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
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
                        'Vérifier',
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
