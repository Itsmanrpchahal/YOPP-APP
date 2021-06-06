import 'package:flutter/material.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/pdf_screen.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/settings_page.dart';
import 'package:yopp/routing/transitions.dart';

class FaqPage extends StatelessWidget {
  static Route get route {
    return SlideRoute(
      builder: (context) => FaqPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: "FAQs",
      detailsWidget: PDFScreen(
        pdfName: "assets/documents/faq.pdf",
      ),
    );
  }
}
