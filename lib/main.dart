import 'package:flutter/material.dart';
import 'package:inventi_app/pages/home/home.dart';
import 'package:inventi_app/providers/text_provider.dart';
import 'package:provider/provider.dart';

import 'accounts/accounts_manager.dart';
import 'api/http_service.dart';
import 'pages/server_error.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<TextProvider>(
      create: (context) => TextProvider(),
      child: const MyApp(),
    ),
    // ChangeNotifierProvider<CallbackProvider>(create: (context) => CallbackProvider()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/accounts': (context) => const Accounts(msg: 'Enter your credentials to proceed'),
      },
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Future auth;
  late dynamic apiResponse;

  @override
  void initState() {
    super.initState();
    auth = HttpService().authenticate();
    auth.then((value) {
      setState(() {
        apiResponse = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      // New user or device
      if (apiResponse == false) {
        return const Accounts(
          msg: 'Enter your credentials to proceed',
        );
      }
      // Successful authentication.
      else if (apiResponse.statusCode == 200) {
        // return _allowUserWidget();
        return const Home();
      }
      // Invalid token: user may not be present in database or token might be expired.
      else if (apiResponse.statusCode == 401) {
        return const Accounts(
          msg: 'Token expired, sign in again',
        );
      }
      // Request Timeout | HTTP Class 500
      else {
        return ResponseCodeWidget(response: apiResponse);
      }
    } catch (error) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
