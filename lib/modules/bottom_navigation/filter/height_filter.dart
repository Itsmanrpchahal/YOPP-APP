import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

class HeightFilter extends StatefulWidget {
  @override
  _HeightFilterState createState() => _HeightFilterState();
}

class _HeightFilterState extends State<HeightFilter> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: AppColors.green,
            alignment: Alignment.center,
            height: 60,
            child: Text(
              "ADD YOUR HEIGHT",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Selected Sport Requires Height",
                    style: TextStyle(color: AppColors.green, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.green,
                        size: 14,
                      ),
                      Text(
                        "Dancing",
                        style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      Icon(
                        Icons.arrow_back,
                        color: AppColors.green,
                        size: 14,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(
                top: 32,
                left: 32,
                right: 32,
                bottom: 32 + MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), color: Colors.white),
            child: Form(
              key: formkey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  CustomTextField(
                    controller: controller,
                    suffixText: " cm",
                    textAlign: TextAlign.center,
                    placeHolderText: "Height",
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    validator: (value) {
                      final height = int.tryParse(value);
                      if (height == null) {
                        return "Enter your height in cm.";
                      }
                      if (height < 1 || height > 272) {
                        return "Enter your actual height in cm.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  FlatButton(
                    color: AppColors.green,
                    height: 50,
                    onPressed: () {
                      if (formkey.currentState.validate()) {
                        final height = int.tryParse(controller.text);
                        if (height != null) {
                          Navigator.of(context).pop();
                          BlocProvider.of<ProfileBloc>(context)
                              .add(UpdateUserProfileEvent(
                                  profile: UserProfile(
                                    height: height,
                                  ),
                                  addSportAfterCompletion: true));
                        }
                      } else {
                        print("invalidate");
                      }
                    },
                    child: Text(
                      "CONFIRM",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
