import 'package:flutter/material.dart';

import 'package:yopp/widgets/body/full_gradient_scaffold.dart';

class SplashSceen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            "assets/icons/splash.png",
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
