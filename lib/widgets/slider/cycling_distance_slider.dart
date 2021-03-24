import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class CyclingDistanceSlider extends CustomSlider {
  final CyclingLevel level;

  final Function(CyclingLevel level) onChange;
  CyclingDistanceSlider({
    @required this.level,
    @required this.onChange,
  });

  @override
  _CyclingDistanceSliderState createState() => _CyclingDistanceSliderState();
}

class _CyclingDistanceSliderState extends State<CyclingDistanceSlider> {
  CyclingLevel level;

  @override
  void initState() {
    level = widget.level ?? CyclingLevel.level1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: 0,
      maxValue: CyclingLevel.values.length.toDouble() - 1,
      value: level.index.toDouble(),
      leadingTitle: "Distance",
      trailingTitle: level.name,
      onChanged: (value) {
        setState(() {
          level = CyclingLevel.values[value.toInt()];
        });

        widget.onChange(level);
      },
    );
  }
}
