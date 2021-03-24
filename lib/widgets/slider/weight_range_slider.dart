import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';
import 'base_range_slider.dart';

class WeightRangeSlider extends StatelessWidget {
  final RangeValues rangeValues;

  final Function(RangeValues) onChanged;

  WeightRangeSlider({
    @required this.rangeValues,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BaseRangeSlider(
      minValue: PreferenceConstants.minWeight,
      values: rangeValues,
      maxValue: PreferenceConstants.maxWeight,
      leadingTitle: "Weight",
      trailingTitle: rangeValues.start.toInt().toString() +
          "-" +
          rangeValues.end.toInt().toString() +
          " Kg",
      onChanged: (values) {
        onChanged(values);
      },
    );
  }
}
