import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';

class NoUserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.verticalLinearGradient),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "N0-ONE \nAVAILABLE",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
          LayoutBuilder(builder: (context, constraint) {
            return SvgPicture.asset(
              "assets/sports/no_user.svg",
              width: constraint.maxWidth / 2.5,
              fit: BoxFit.contain,
            );
          }),
          Expanded(
            child: Center(
              child: Text(
                "Oops, no match, but stay tuned we are growing daily.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Try changing your selection (age, distance etc) or sport and see who is available to practise with you. It’s a great time to try something new.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
