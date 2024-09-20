import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventi_app/pages/generated_texts/generated_texts_widget.dart';
import 'package:inventi_app/pages/home/home_widgets.dart';
import 'package:provider/provider.dart';

import '../../accounts/secure_storage.dart';
import '../../api/http_service.dart';
import '../../api/models.dart';
import '../../providers/text_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? username;
  String? email;
  String? token;

  HttpService httpService = HttpService();
  Future<Logout>? _futureLogout;

  @override
  void initState() {
    super.initState();
    getUserInfoFromStorage();
  }

  void getUserInfoFromStorage() async {
    var user = await UserSecureStorage.getUser();
    var userToken = await UserSecureStorage.getToken();
    setState(() {
      username = user['username'];
      email = user['email'];
      token = userToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7FF),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/hamburger.svg',
                  color: const Color(0xFF4190FF),
                  width: 100,
                  height: 100,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            );
          },
        ),
        title: SvgPicture.asset(
          'assets/icons/logo.svg',
          width: 40,
          height: 40,
        ),
        backgroundColor: const Color(0xFFF1F7FF),
        elevation: 0.0,
        toolbarHeight: 70,
        titleSpacing: 0,
      ),
      body: const SafeArea(
        child: RandomTextWidget(),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                username ?? 'loading...',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 30),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Generated Texts'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneratedTexts()));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _futureLogout = httpService.logout(userToken: token ?? '');

                _futureLogout!.then((value) {
                  if (value.http204Message != null) {
                    Navigator.popAndPushNamed(context, '/accounts');
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
