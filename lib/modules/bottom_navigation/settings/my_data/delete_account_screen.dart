import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/bottom_navigation/settings/my_data/delete_options.dart';
import 'package:yopp/modules/bottom_navigation/settings/my_data/confirm_delete_screen.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';

class DeleteAccountScreen extends StatefulWidget {
  static Route get route {
    return FadeRoute(
      builder: (context) => DeleteAccountScreen(),
    );
  }

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  var selectedDeleteOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new DefaultAppBar(
        titleText: "Delete Account",
        context: context,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: _buildBodyDetail(context)),
            ),
            SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildBodyDetail(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 30),
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Text(
                  "Are you sure you want to delete your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Hexcolor("#212121")),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  "Please help us make the app better, by letting us know the reason why you are leaving.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Hexcolor("#212121"), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        _buildDeleteOptionListTiles(context, DeleteOptionEnum.needBreak),
        _buildDeleteOptionListTiles(context, DeleteOptionEnum.dontLike),
        _buildDeleteOptionListTiles(context, DeleteOptionEnum.startOver),
        _buildDeleteOptionListTiles(context, DeleteOptionEnum.somethingBroken),
        _buildDeleteOptionListTiles(context, DeleteOptionEnum.somethingElse),
      ],
    );
  }

  _buildDeleteOptionListTiles(BuildContext context, DeleteOptionEnum option) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: SwitchListTile(
          value: selectedDeleteOption == option,
          onChanged: (c) {
            // setState(() {
            //   selectedDeleteOption = option;
            // });
            _showConfirmDeleteScreen(option);
          },
          title: Text(
            option.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Hexcolor("##212121").withOpacity(0.77)),
          ),
          inactiveThumbColor: AppColors.lightGrey,
          activeColor: Colors.white,
          inactiveTrackColor: AppColors.lightGrey.withOpacity(0.5),
          activeTrackColor: AppColors.lightGrey.withOpacity(0.5)),
    );
  }

  _showConfirmDeleteScreen(DeleteOptionEnum selectedDeleteOption) {
    Navigator.of(context).push(ConfirmDeleteAccountScreen.route(
        selectedDeleteOption: selectedDeleteOption));
  }
}
