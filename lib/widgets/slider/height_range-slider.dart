import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';
import 'base_range_slider.dart';

class HeightRangeSlider extends StatelessWidget {
  final RangeValues rangeValues;

  final Function(RangeValues) onChanged;

  HeightRangeSlider({
    @required this.rangeValues,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BaseRangeSlider(
      minValue: PreferenceConstants.minHeightValue,
      values: rangeValues,
      maxValue: PreferenceConstants.maxHeightValue,
      leadingTitle: "Height",
      trailingTitle: rangeValues.start.toInt().toString() +
          "-" +
          rangeValues.end.toInt().toString() +
          " Cm",
      onChanged: (values) {
        onChanged(values);
      },
    );
  }
}
