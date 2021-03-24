import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class SkillLevelSlider extends CustomSlider {
  final SkillLevel level;
  final bool showAll;
  final Function(SkillLevel level) onChange;
  SkillLevelSlider({
    this.level,
    this.onChange,
    this.showAll = true,
  });

  @override
  _SkillLevelSliderState createState() => _SkillLevelSliderState();
}

class _SkillLevelSliderState extends State<SkillLevelSlider> {
  SkillLevel level;
  var offset;

  @override
  void initState() {
    level = widget.level ?? SkillLevel.beginner;
    offset = widget.showAll ? 1 : 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: 0,
      maxValue: SkillLevel.values.length.toDouble() - offset,
      value: level.index.toDouble(),
      leadingTitle: "Skill Level",
      trailingTitle: level.name,
      onChanged: (value) {
        setState(() {
          level = SkillLevel.values[value.toInt()];
        });

        widget.onChange(level);
      },
    );
  }
}
