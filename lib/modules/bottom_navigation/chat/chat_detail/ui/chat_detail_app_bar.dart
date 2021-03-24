import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/icons/circular_profile_icon.dart';

class ChatDetailAppBar extends AppBar {
  final BuildContext context;
  final Color color;
  final String titleText;
  final String imageUrl;
  final bool isOnline;
  final Gender gender;
  final String heroTag;
  final Function onProfileTap;
  final Function onBack;
  final Function onTrailingTap;

  final Function onBlockUser;
  final Function onReportUser;

  static const _reportUser = "Report User";
  static const _blockUser = "Block User";

  ChatDetailAppBar(
      {@required this.context,
      this.color,
      this.titleText,
      this.imageUrl,
      this.isOnline,
      this.heroTag,
      this.onProfileTap,
      this.onBack,
      this.onTrailingTap,
      @required this.onBlockUser,
      @required this.onReportUser,
      @required this.gender});
  @override
  Color get backgroundColor => Colors.transparent;

  @override
  List<Widget> get actions => [
        Container(
          padding: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            onSelected: (String value) {
              if (value == _reportUser) {
                print("report");
                onReportUser();
              }
              if (value == _blockUser) {
                print("_blockUser");
                onBlockUser();
              }
            },
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: _reportUser,
                child: Text(
                  _reportUser,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const PopupMenuItem<String>(
                value: _blockUser,
                child: Text(
                  _blockUser,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ];

  @override
  double get elevation => 0;
  @override
  bool get centerTitle => true;

  @override
  Widget get leading => Container(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(16, 0),
          child: CircleIconButton(
            radius: 21,
            backgrounColor: Colors.white10,
            onPressed: () {
              onBack();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      );

  @override
  Widget get title => GestureDetector(
        onTap: onProfileTap,
        child: Container(
          padding: EdgeInsets.only(left: 40),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: heroTag,
                child: CircularProfileIcon(
                  imageUrl: imageUrl,
                  gender: gender,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            titleText ?? "",
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 4),
                    isOnline == true
                        ? Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Online",
                                  style: TextStyle(
                                    color: Hexcolor("#14B28B"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key key,
    @required this.onPressed,
    this.icon,
    this.radius = 22,
    this.backgrounColor,
  }) : super(key: key);

  final double radius;
  final Function onPressed;
  final Widget icon;
  final Color backgrounColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        child: icon ??
            Icon(
              Icons.check,
              color: AppColors.orange,
              size: radius,
            ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgrounColor ?? Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
            ]),
      ),
    );
  }
}
