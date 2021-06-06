import 'package:flutter/material.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/pdf_screen.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/settings_page.dart';
import 'package:yopp/routing/transitions.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static Route get route {
    return SlideRoute(
      builder: (context) => PrivacyPolicyScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: "Privacy Policy",
      detailsWidget: PDFScreen(
        pdfName: "assets/documents/privacy_policy.pdf",
      ),
    );
  }
}
