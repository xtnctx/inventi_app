import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventi_app/providers/text_provider.dart';
import 'package:inventi_app/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

import '../../api/http_service.dart';
import '../../api/models.dart';

class RandomTextWidget extends StatefulWidget {
  const RandomTextWidget({super.key});

  @override
  State<RandomTextWidget> createState() => _RandomTextWidgetState();
}

class _RandomTextWidgetState extends State<RandomTextWidget> {
  HttpService httpService = HttpService();
  Future<TextGenerated>? _futureText;

  String? newText;

  Future<String> _generateText() async {
    final response = await httpService.generateText();
    return response.randomString;
  }

  Future showTextGeneratorErrorDialog(error, stackTrace) {
    String c = error.toString();
    return showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(content: c);
      },
    );
  }

  void addToPage(TextProvider textProvider, String text) {
    textProvider.add(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 150,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFABCEFF),
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<TextGenerated>(
                future: _futureText,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading state
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error state
                  } else {
                    final displayText = snapshot.data?.randomString ?? "Quick Button";

                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          displayText,
                          style: GoogleFonts.roboto(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF092768),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Consumer<TextProvider>(
                  builder: (BuildContext context, TextProvider textProvider, Widget? child) {
                return TextButton(
                  onPressed: () async {
                    _futureText = httpService.generateText();

                    _futureText?.then((value) {
                      setState(() {
                        newText = value.randomString;
                      });

                      // Provider
                      addToPage(textProvider, newText!);
                      //
                    }).onError((error, _) {
                      showTextGeneratorErrorDialog(error, _);
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF1F6BD7),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/wrench.svg',
                          width: 22,
                          height: 22,
                        ),
                        Text(
                          "Click the button to generate new random string",
                          style: GoogleFonts.roboto(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
