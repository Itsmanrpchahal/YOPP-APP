import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class RunningDistanceSlider extends CustomSlider {
  final RunningLevel level;

  final Function(RunningLevel level) onChange;
  RunningDistanceSlider({
    @required this.level,
    @required this.onChange,
  });

  @override
  _RunningDistanceSliderState createState() => _RunningDistanceSliderState();
}

class _RunningDistanceSliderState extends State<RunningDistanceSlider> {
  RunningLevel level;

  @override
  void initState() {
    level = widget.level ?? RunningLevel.level1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: 0,
      maxValue: RunningLevel.values.length.toDouble() - 1,
      value: level.index.toDouble(),
      leadingTitle: "Distance",
      trailingTitle: level.name,
      onChanged: (value) {
        setState(() {
          level = RunningLevel.values[value.toInt()];
        });

        widget.onChange(level);
      },
    );
  }
}
