import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class WeightSlider extends CustomSlider {
  final double weight;
  final Function(double weight) onChanged;

  WeightSlider({this.weight, this.onChanged});
  @override
  _WeightSliderState createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  double weight;

  @override
  void initState() {
    weight = widget.weight ?? PreferenceConstants.defaultWeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: PreferenceConstants.minWeight,
      value: weight,
      maxValue: PreferenceConstants.maxWeight,
      leadingTitle: "Weight",
      trailingTitle: weight.toInt().toString() + " Kg",
      onChanged: (val) {
        setState(() {
          weight = val;
          widget.onChanged(weight);
        });
      },
    );
  }
}
