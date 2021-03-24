import 'package:flutter/material.dart';

import 'package:yopp/modules/_common/sports/data/requirements/swimming_requirements.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class SwimmingDistanceSlider extends CustomSlider {
  final SwimmingLevel level;

  final Function(SwimmingLevel level) onChange;
  SwimmingDistanceSlider({
    @required this.level,
    @required this.onChange,
  });

  @override
  _SwimmingDistanceSliderState createState() => _SwimmingDistanceSliderState();
}

class _SwimmingDistanceSliderState extends State<SwimmingDistanceSlider> {
  SwimmingLevel level;

  @override
  void initState() {
    level = widget.level ?? SwimmingLevel.level1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: 0,
      maxValue: SwimmingLevel.values.length.toDouble() - 1,
      value: level.index.toDouble(),
      leadingTitle: "Distance",
      trailingTitle: level.name,
      onChanged: (value) {
        setState(() {
          level = SwimmingLevel.values[value.toInt()];
        });

        widget.onChange(level);
      },
    );
  }
}
