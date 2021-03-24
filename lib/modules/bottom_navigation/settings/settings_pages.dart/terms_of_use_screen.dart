import 'package:flutter/material.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/pdf_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/settings_page.dart';
import 'package:yopp/routing/transitions.dart';

class TermsofUseScreen extends StatelessWidget {
  static Route get route {
    return FadeRoute(
      builder: (context) => TermsofUseScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: "Terms of Use",
      detailsWidget: PDFScreen(
        pdfName: "assets/documents/terms.pdf",
      ),
    );
  }
}
