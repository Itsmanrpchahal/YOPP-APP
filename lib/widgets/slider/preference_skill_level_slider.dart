import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

import 'base_preference_slider.dart';

class PreferenceSkillSlider extends StatelessWidget {
  final SkillLevel skillLevel;
  final Function(SkillLevel level) onChange;
  PreferenceSkillSlider({this.skillLevel, this.onChange});

  @override
  Widget build(BuildContext context) {
    return BasePreferenceSlider(
      minValue: 0,
      maxValue: SkillLevel.values.length.toDouble() - 1,
      value: skillLevel == null ? 0 : skillLevel.index.toDouble(),
      leadingTitle: "Skill Level",
      trailingTitle: skillLevel?.name ?? "",
      onChanged: (value) {
        final level = SkillLevel.values[value.toInt()];
        onChange(level);
      },
    );
  }
}
