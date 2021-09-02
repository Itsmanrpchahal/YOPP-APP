import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/widgets/slider/slider_theme.dart';

class BaseRangeSlider extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final RangeValues values;
  final String leadingTitle;
  final String trailingTitle;
  final Function(RangeValues) onChanged;

  const BaseRangeSlider(
      {Key key,
      @required this.minValue,
      @required this.maxValue,
      @required this.values,
      this.leadingTitle,
      this.trailingTitle,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
          child: RangeSlider(
            min: minValue,
            max: maxValue,
            divisions: (maxValue - minValue).toInt(),
            values: values,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
