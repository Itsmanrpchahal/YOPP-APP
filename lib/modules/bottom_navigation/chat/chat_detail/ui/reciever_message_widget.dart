import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/icons/circular_profile_icon.dart';

class RecievedMessageWidget extends StatelessWidget {
  final String message;
  final String imageUrl;
  final Gender gender;
  final bool isOnline;

  const RecievedMessageWidget(
      {Key key,
      this.message,
      this.imageUrl,
      @required this.gender,
      @required this.isOnline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width * 0.7;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ActiveCircularProfileIcon(
          size: 42,
          imageUrl: imageUrl,
          gender: gender,
          isOnline: isOnline,
        ),
        SizedBox(width: 8),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 80, maxWidth: maxWidth - 42),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Hexcolor("#222222").withOpacity(0.25),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
