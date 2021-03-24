import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class AppGradients {
  static LinearGradient get verticalLinearGradient {
    return LinearGradient(
      colors: [AppColors.green, AppColors.darkBlue],
      stops: [0.2, 0.8],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static LinearGradient get backgroundGradient {
    return LinearGradient(
      colors: [
        AppColors.darkBlue,
        AppColors.blue,
        AppColors.lightGreen,
        AppColors.green
      ],
      stops: [0.0, 0.33, 0.66, 1],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
  }

  static LinearGradient get halfBackgroundGradient {
    return LinearGradient(
      colors: [
        AppColors.green,
        AppColors.lightGreen,
        AppColors.blue,
        AppColors.darkBlue,
      ],
      stops: [0.0, 0.33, 0.66, 1],
      begin: Alignment.topRight,
      end: FractionalOffset.bottomLeft,
    );
  }
}
