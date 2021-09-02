import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

class NameBottomSheet {
  static show(BuildContext context, String about) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final controller = TextEditingController(text: about ?? "");

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
              padding: EdgeInsets.only(
                  top: 32,
                  left: 32,
                  right: 32,
                  bottom: 32 + MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: Form(
                key: formkey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    CustomTextField(
                      controller: controller,
                      placeHolderText: "Name",
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return value.length > 0 ? null : "Enter you name.";
                      },
                    ),
                    SizedBox(height: 16),
                    FlatButton(
                      color: AppColors.green,
                      height: 50,
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (formkey.currentState.validate()) {
                          BlocProvider.of<ProfileBloc>(context).add(
                              UpdateUserProfileEvent(
                                  profile: UserProfile(name: controller.text)));
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
            ));
  }
}
