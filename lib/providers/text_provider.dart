import 'package:flutter/material.dart';

class TextProvider extends ChangeNotifier {
  final List<String> _generatedTexts = [];

  List<String> get generatedTexts => _generatedTexts;

  void add(String text) {
    _generatedTexts.add(text);
    notifyListeners();
  }

  void clearTexts() {
    _generatedTexts.clear();
    notifyListeners();
  }
}
