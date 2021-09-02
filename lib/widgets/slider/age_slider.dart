import 'package:flutter/material.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/widgets/slider/custom_slider.dart';

class AgeSlider extends CustomSlider {
  final double age;
  final Function(double age) onChanged;

  AgeSlider({this.age, this.onChanged});
  @override
  _AgeSliderState createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  double age;

  @override
  void initState() {
    age = widget.age ?? PreferenceConstants.defaultStartAgeValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSlider(
      minValue: PreferenceConstants.minAgeValue,
      maxValue: PreferenceConstants.maxAgeValue,
      value: age,
      leadingTitle: "Age",
      trailingTitle: age.toInt().toString() + " Years",
      onChanged: (val) {
        setState(() {
          age = val;
          widget.onChanged(age);
        });
      },
    );
  }
}
