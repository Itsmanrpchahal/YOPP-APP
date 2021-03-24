import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';

import 'base_range_slider.dart';

class AgeRangeSlider extends StatelessWidget {
  final RangeValues ageRange;
  final Function(RangeValues) onChanged;

  AgeRangeSlider({
    @required this.ageRange,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BaseRangeSlider(
        minValue: PreferenceConstants.minAgeValue,
        values: ageRange,
        maxValue: PreferenceConstants.maxAgeValue,
        leadingTitle: "Age",
        trailingTitle: ageRange.start.toInt().toString() +
            "-" +
            ageRange.end.toInt().toString() +
            " Years",
        onChanged: (values) {
          onChanged(values);
        },
      ),
    );
  }
}
