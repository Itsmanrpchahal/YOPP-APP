import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yopp/helper/app_color/app_gradients.dart';

class NoUserWidget extends StatelessWidget {
  final double height;

  const NoUserWidget({Key key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(gradient: AppGradients.verticalLinearGradient),
      child: Column(
        children: [
          Spacer(),
          Text(
            "N0-ONE \nAVAILABLE",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
          Spacer(),
          Flexible(
            flex: 10,
            child: SvgPicture.asset(
              "assets/sports/no_user.svg",
              fit: BoxFit.contain,
            ),
          ),
          Spacer(),
          Text(
            "Oops, no match, but stay tuned we are growing daily.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Spacer(),
          Text(
            "Try changing your selection (age, distance etc) or sport and see who is available to practise with you. It’s a great time to try something new.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
