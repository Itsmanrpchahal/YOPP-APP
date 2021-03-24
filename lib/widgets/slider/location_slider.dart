import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/widgets/slider/base_preference_slider.dart';

class LocationSlider extends StatelessWidget {
  final double range;
  final Function(double value) onChanged;

  LocationSlider({
    @required this.range,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BasePreferenceSlider(
      minValue: PreferenceConstants.minLocationRange,
      maxValue: PreferenceConstants.maxLocationRange,
      value: range ?? PreferenceConstants.defaultLocationRangeValue,
      leadingTitle: "Distance",
      trailingTitle: range.toInt().toString() + " Km",
      onChanged: (val) {
        onChanged(val);
      },
    );
  }
}
