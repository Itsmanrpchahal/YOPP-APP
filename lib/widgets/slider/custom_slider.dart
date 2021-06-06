import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/widgets/slider/slider_theme.dart';

abstract class CustomSlider extends StatefulWidget {}

class BaseSlider extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double value;
  final String leadingTitle;
  final String trailingTitle;
  final Function(double) onChanged;

  const BaseSlider(
      {Key key,
      this.minValue,
      this.maxValue,
      this.value = 0,
      this.leadingTitle,
      this.trailingTitle,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leadingTitle ?? "",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green),
              ),
              Text(
                trailingTitle ?? "",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: CustomSliderTheme.darkData,
          child: Slider(
            min: minValue,
            max: maxValue,
            divisions: maxValue.toInt(),
            value: value,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
