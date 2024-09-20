import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventi_app/providers/text_provider.dart';
import 'package:provider/provider.dart';

class GeneratedTexts extends StatelessWidget {
  const GeneratedTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generated Texts"),
      ),
      body: Consumer<TextProvider>(
        builder: (BuildContext context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: value.generatedTexts.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                          value.generatedTexts[index],
                          style: GoogleFonts.roboto(fontSize: 40, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    value.clearTexts();
                  },
                  child: const Text("Clear all"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
