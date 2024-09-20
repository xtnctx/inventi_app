import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class Accounts extends StatefulWidget {
  final String msg;
  const Accounts({super.key, required this.msg});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  int currentPage = 0;
  String msg = '';

  @override
  void initState() {
    msg = widget.msg;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      // Used IndexedStack to save the state
      // so inputs are saved even when navigating
      // back and forth between pages (login & register)
      child: IndexedStack(
        index: currentPage,
        children: [
          LoginPage(
            msg: msg,
            onButtonPressed: () {
              setState(() {
                currentPage = 1;
              });
            },
          ),
          RegisterPage(onButtonPressed: () {
            setState(() {
              currentPage = 0;
            });
          }),
        ],
      ),
    ));
  }
}
