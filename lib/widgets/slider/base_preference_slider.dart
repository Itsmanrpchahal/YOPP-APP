import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/widgets/slider/slider_theme.dart';

class BasePreferenceSlider extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double value;
  final String leadingTitle;
  final String trailingTitle;
  final Function(double) onChanged;

  const BasePreferenceSlider(
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
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Hexcolor("#222222")),
              ),
              Text(
                trailingTitle ?? "",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Hexcolor("#222222").withOpacity(0.5)),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: CustomSliderTheme.rangeTheme,
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
