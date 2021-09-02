import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';

import 'package:yopp/widgets/slider/custom_slider.dart';

class HeightSlider extends CustomSlider {
  final double height;
  final Function(double value) onChanged;

  HeightSlider({
    this.height,
    this.onChanged,
  });
  @override
  _HeightSliderState createState() => _HeightSliderState();
}

class _HeightSliderState extends State<HeightSlider> {
  double height;

  @override
  void initState() {
    height = widget.height ?? PreferenceConstants.defaultHeightValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: PreferenceConstants.minHeightValue,
      value: height,
      maxValue: PreferenceConstants.maxHeightValue,
      leadingTitle: "Height",
      trailingTitle: height.toInt().toString() + " Cm",
      onChanged: (val) {
        setState(() {
          height = val;
          widget.onChanged(height);
        });
      },
    );
  }
}
