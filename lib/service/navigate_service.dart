import 'package:flutter/material.dart';

class NavigateService {
  static Future<void> push(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return screen;
        },
      ),
    );
  }
}
