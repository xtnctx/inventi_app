// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventi_app/widgets/error_dialog.dart';

import '../api/http_service.dart';
import '../api/models.dart';
import 'secure_storage.dart';

class LoginPage extends StatefulWidget {
  final String msg;
  final VoidCallback onButtonPressed;
  const LoginPage({super.key, required this.onButtonPressed, required this.msg});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;

  HttpService httpService = HttpService();
  Future<Login>? _futureLogin;

  String? msg;

  @override
  void initState() {
    msg = widget.msg;
    super.initState();
  }

  Future showLoginErrorDialog(error, stackTrace) {
    String? c;
    if (error is Login) {
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
                    'Sign in',
                    style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      msg!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email address textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
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
                          hintText: 'Email Address',
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
                            child: TextField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              autocorrect: false,
                              enableSuggestions: false,
                              textAlignVertical: TextAlignVertical.center,
                              // ignore: deprecated_member_use
                              toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true,
                              ),
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

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Sign in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F6BD7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _futureLogin = httpService.login(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          });

                          _futureLogin?.then((value) async {
                            Navigator.popAndPushNamed(context, '/');
                            await UserSecureStorage.setUser(user: value.user);
                            await UserSecureStorage.setToken(token: value.token);
                          }).onError((error, _) {
                            showLoginErrorDialog(error, _);
                          });
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Don\'t have an account?',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: widget.onButtonPressed,
                        child: Text(
                          ' Sign up here',
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
