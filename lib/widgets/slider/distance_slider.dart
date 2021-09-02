import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class DistanceSlider extends CustomSlider {
  final double distance;
  final Function(double value) onChanged;

  DistanceSlider({
    this.distance,
    this.onChanged,
  });
  @override
  _DistanceSliderState createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  double distance;

  @override
  void initState() {
    distance = widget.distance ?? PreferenceConstants.defaultDistance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: PreferenceConstants.minDistance,
      value: distance,
      maxValue: PreferenceConstants.maxDistance,
      leadingTitle: "Distance",
      trailingTitle: distance.toInt().toString() + " Km",
      onChanged: (val) {
        setState(() {
          distance = val;
          widget.onChanged(distance);
        });
      },
    );
  }
}
