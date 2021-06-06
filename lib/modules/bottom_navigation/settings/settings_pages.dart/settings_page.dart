import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';

class SettingsPage extends StatelessWidget {
  static Route route({
    @required String title,
    @required String details,
  }) {
    return FadeRoute(
      builder: (context) => SettingsPage(
        title: title,
        details: details,
      ),
    );
  }

  const SettingsPage({
    Key key,
    this.title,
    this.details,
    this.detailsWidget,
  }) : super(key: key);

  final String title;
  final String details;
  final Widget detailsWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new DefaultAppBar(
        context: context,
        titleText: title,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: detailsWidget != null
          ? Container(
              child: detailsWidget,
              width: double.infinity,
              height: double.infinity,
            )
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 36),
                  ),
                  SizedBox(height: 20),
                  Text(
                    details,
                    style: TextStyle(
                        color: Hexcolor("#222222"),
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ],
              )),
    );
  }
}
