// import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import './app_theme.dart';

// class AppThemeState extends ChangeNotifier {
//   bool isDarkMode = false;

//   AppThemeState() {
//     _getStoredTheme();
//   }

//   _getStoredTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final darkMode = prefs.getBool("isDarkMode");
//     if (darkMode != null) {
//       isDarkMode = darkMode;
//     }
//     notifyListeners();
//   }

//   ThemeData get themeData =>
//       isDarkMode ? AppTheme.darkThemeData : AppTheme.lightThemeData;

//   void updateTheme(bool isDarkModeOn) async {
//     isDarkMode = isDarkModeOn;
//     await SharedPreferences.getInstance()
//       ..setBool("isDarkMode", isDarkModeOn);
//     notifyListeners();
//   }
// }
