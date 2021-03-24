import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class PaceSlider extends CustomSlider {
  final PaceLevel level;
  final Function(PaceLevel pace) onChanged;

  PaceSlider({this.level, this.onChanged});
  @override
  _PaceSliderState createState() => _PaceSliderState();
}

class _PaceSliderState extends State<PaceSlider> {
  PaceLevel level;

  @override
  void initState() {
    level = widget.level ?? PaceLevel.slow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: 0,
      value: level.index.toDouble(),
      maxValue: PaceLevel.values.length.toDouble() - 2,
      leadingTitle: "Pace",
      trailingTitle: level.name,
      onChanged: (value) {
        setState(() {
          level = PaceLevel.values[value.toInt()];
          widget.onChanged(level);
        });
      },
    );
  }
}
