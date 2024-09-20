// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/http_service.dart';
import '../api/models.dart';
import '../widgets/error_dialog.dart';
import 'secure_storage.dart';
import 'package:inventi_app/accounts/string_validators.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onButtonPressed;
  const RegisterPage({super.key, required this.onButtonPressed});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  HttpService httpService = HttpService();
  Future<RegisterModel>? _futureRegister;

  Future showRegisterErrorDialog(error, stackTrace) {
    String? c;
    if (error is RegisterModel) {
      Map<String, dynamic>? nerror = error.errorMsg;
      c = '${nerror!.values.first[0]}';
    } else {
      c = error.toString();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(content: c!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage('assets/images/accounts_bg.jpg'),
              ),
            ),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    'Sign up',
                    style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (input) => input!.isValidUsername(),
                              controller: userNameController,
                              autocorrect: false,
                              toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Username',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Email textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (input) => input!.isValidEmail(),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Email',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Password textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (input) => input!.isValidPassword(),
                                    controller: passwordController,
                                    obscureText: _obscureText,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    textAlignVertical: TextAlignVertical.center,
                                    toolbarOptions: const ToolbarOptions(),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Password',
                                      contentPadding: const EdgeInsets.only(left: 20.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Confirm password textfield
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (input) {
                                if (input != passwordController.text) return 'Passwords do not match';
                                return null;
                              },
                              controller: confirmPasswordController,
                              autocorrect: false,
                              enableSuggestions: false,
                              obscureText: true,
                              toolbarOptions: const ToolbarOptions(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Confirm password',
                                contentPadding: EdgeInsets.only(left: 20.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Sign up button
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F6BD7),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Send post request to server
                                        setState(() {
                                          _futureRegister = httpService.register(
                                            username: userNameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        });

                                        // Save response (user credentials) to secure storage
                                        _futureRegister?.then((value) async {
                                          Navigator.popAndPushNamed(context, '/');
                                          await UserSecureStorage.setUser(user: value.user);
                                          await UserSecureStorage.setToken(token: value.token);
                                        }).onError((error, _) {
                                          showRegisterErrorDialog(error, _);
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Already have an account?',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: widget.onButtonPressed,
                        child: Text(
                          ' Sign In',
                          style: GoogleFonts.roboto(
                              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
