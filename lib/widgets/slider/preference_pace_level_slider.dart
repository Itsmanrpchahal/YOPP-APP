import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/widgets/slider/base_preference_slider.dart';

class PreferencePaceSlider extends StatelessWidget {
  final PaceLevel level;
  final Function(PaceLevel level) onChange;
  PreferencePaceSlider({this.level, this.onChange});

  @override
  Widget build(BuildContext context) {
    return BasePreferenceSlider(
      minValue: 0,
      maxValue: PaceLevel.values.length.toDouble() - 1,
      value: level == null ? 0 : level.index.toDouble(),
      leadingTitle: "Pace",
      trailingTitle: level?.name ?? "",
      onChanged: (value) {
        final level = PaceLevel.values[value.toInt()];
        onChange(level);
      },
    );
  }
}
