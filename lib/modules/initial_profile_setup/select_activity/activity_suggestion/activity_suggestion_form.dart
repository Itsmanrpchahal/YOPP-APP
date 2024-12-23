import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_sugession_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_suggestion_state.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/textfield/auth_field.dart';

import 'bloc/activity_suggestion_event.dart';

class ActivitySuggestionForm extends StatefulWidget {
  @override
  _ActivitySuggestionFormState createState() => _ActivitySuggestionFormState();
}

class _ActivitySuggestionFormState extends State<ActivitySuggestionForm> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _sportController = TextEditingController(text: "");

  @override
  void dispose() {
    _sportController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocListener<ActivitySugessionBloc, ActivitySuggestionState>(
        listener: (context, state) async {
          ProgressHud.of(context).dismiss();
          print(state.status);
          switch (state.status) {
            case ActivitySuggestionStatus.initial:
              break;
            case ActivitySuggestionStatus.loadingInitial:
              break;
            case ActivitySuggestionStatus.loadingPrevious:
              break;
            case ActivitySuggestionStatus.loadingInitialSuccess:
              break;
            case ActivitySuggestionStatus.loadingPreviousSuccess:
              break;
            case ActivitySuggestionStatus.posting:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.serviceMessage);
              break;
            case ActivitySuggestionStatus.posted:
              await ProgressHud.of(context).showAndDismiss(
                  ProgressHudType.success, state.serviceMessage);
              Navigator.of(context).pop();
              break;
            case ActivitySuggestionStatus.failed:
              ProgressHud.of(context)
                  .showAndDismiss(ProgressHudType.error, state.serviceMessage);
              break;
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 16, left: 32, right: 32),
          child: Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Your Input",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: AppColors.green),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "What additional sports/activities would you like added?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: AppColors.green),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _sportController,
                    placeHolderText: "Enter the name.",
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return value.isNotEmpty
                          ? null
                          : "Please, Enter the sport/activity, you would like add.";
                    },
                  ),
                  SizedBox(height: 32),
                  FlatButton(
                    color: AppColors.green,
                    height: 50,
                    onPressed: () => saveAction(context),
                    child: Text(
                      "CONFIRM",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              )),
        ),
      );
    });
  }

  saveAction(BuildContext context) {
    if (_formkey.currentState.validate()) {
      BlocProvider.of<ActivitySugessionBloc>(context, listen: false)
          .add(PostActivitySuggestion(_sportController.text));
    }
  }
}
