import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/authentication/bloc/authenication_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
import 'package:yopp/modules/bottom_navigation/settings/my_data/delete_options.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';

import 'package:yopp/widgets/buttons/gradient_check_button.dart';
import 'package:yopp/widgets/buttons/rounded_button.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class ConfirmDeleteAccountScreen extends StatefulWidget {
  static Route route({@required DeleteOptionEnum selectedDeleteOption}) {
    return FadeRoute(
      builder: (context) => ConfirmDeleteAccountScreen(
        selectedDeleteOption: selectedDeleteOption,
      ),
    );
  }

  final DeleteOptionEnum selectedDeleteOption;

  const ConfirmDeleteAccountScreen(
      {Key key, @required this.selectedDeleteOption})
      : super(key: key);

  @override
  _ConfirmDeleteAccountScreenState createState() =>
      _ConfirmDeleteAccountScreenState();
}

class _ConfirmDeleteAccountScreenState
    extends State<ConfirmDeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        appBar: new DefaultAppBar(
          titleText: "Delete Account",
          context: context,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            ProgressHud.of(context).dismiss();
            print(state.status);
            print(state.message);

            switch (state.status) {
              case AuthStatus.updating:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.message);
                break;

              case AuthStatus.unauthenticated:
                Navigator.of(context).popUntil((route) => route.isFirst);
                break;
              case AuthStatus.error:
                await ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;

              default:
                break;
            }
          },
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: _buildBodyDetail(context)),
            ),
            SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildBodyDetail(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "Are you sure you want to delete your account?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Hexcolor("#212121")),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "If you delete your account, you will permanently lose your profile, messages, photos and matches. If you delete your account, you will not be able to recover your account or undo this action.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Hexcolor("#212121"), fontSize: 12),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "If you are unsure, we would recommend pausing your account. Pausing your account will not show you to others.  This is our method of hiding your account so you can take a break if you're unsure. You can always turn this off in the settings menu.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Hexcolor("#212121"), fontSize: 12),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 30, bottom: 30),
          child: Text(
            "Arey you sure you want to delete your account?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Hexcolor("#212121"), fontSize: 12),
          ),
        ),
        RaisedRoundedButton(
          titleText: "DELETE",
          titleStyle: TextStyle(color: Colors.white),
          backgroundColor: Hexcolor("#DF4944"),
          onPressed: () => _deleteAccount(context),
        ),
        SizedBox(height: 30),
        GradientButton(
          child: Text(
            "PAUSE MY ACCOUNT",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _pauseAccount(context),
        ),
      ],
    );
  }

  _deleteAccount(BuildContext context) {
    BlocProvider.of<AuthBloc>(context, listen: false)
        .add(DeleteAccountRequestedEvent(widget.selectedDeleteOption.name));
  }

  _pauseAccount(BuildContext context) {
    BlocProvider.of<AuthBloc>(context, listen: false)
        .add(PauseAccountRequestedEvent());
  }
}
