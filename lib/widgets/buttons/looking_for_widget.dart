import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class LookingForWidget extends StatefulWidget {
  final Gender initialState;
  final Function(Gender gender) onPressed;

  const LookingForWidget({
    Key key,
    @required this.onPressed,
    @required this.initialState,
  }) : super(key: key);
  @override
  _LookingForWidgetState createState() => _LookingForWidgetState();
}

class _LookingForWidgetState extends State<LookingForWidget> {
  Gender gender;

  @override
  void initState() {
    gender = widget.initialState ?? Gender.male;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          Expanded(
            child: Text(
              "I'm Looking for",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            children: [
              Spacer(),
              RadioButtonGroup(
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                labelStyle:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                onSelected: (String selected) {
                  Gender selectedGender;
                  Gender.values.forEach((element) {
                    if (element.name == selected) {
                      selectedGender = element;
                    }
                  });

                  setState(() {
                    widget.onPressed(selectedGender);
                  });
                },
                labels: Gender.values.map((e) => e.name).toList(),
                picked: widget.initialState.name,
                itemBuilder: (Radio rb, Text txt, int i) {
                  return Column(
                    children: <Widget>[
                      rb,
                      txt,
                    ],
                  );
                },
              ),
              Spacer(),
            ],
          ),

          // FlutterSwitch(
          //   value: gender == Gender.male,
          //   width: 100,
          //   toggleColor: Colors.white,
          //   toggleSize: 30,
          //   padding: 2,
          //   activeColor: AppColors.green,
          //   inactiveColor: AppColors.green,
          //   valueFontSize: 13,
          //   activeText: "   Male",
          //   inactiveText: "Female",
          //   showOnOff: true,
          //   onToggle: (value) {
          //     setState(() {
          //       gender = value ? Gender.male : Gender.female;
          //       widget.onPressed(gender);
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
