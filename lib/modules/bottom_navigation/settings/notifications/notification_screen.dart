import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/_common/base_view_model.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_bloc.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_event.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_setting.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_service.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_state.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar_with_cross.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class NotificationScreen extends StatefulWidget {
  static Route get route {
    return FadeRoute(
      builder: (context) => BlocProvider(
        create: (context) => NotificationBloc(FirebaseNotificationService()),
        child: NotificationScreen(),
      ),
    );
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationSetting model;

  @override
  void initState() {
    BlocProvider.of<NotificationBloc>(context).add(GetNotificationOptions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      extendBodyBehindAppBar: false,
      appBar: TransparentAppBarWithCrossAction(
        context: context,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          ProgressHud.of(context).dismiss();
          switch (state.status) {
            case ServiceStatus.none:
              break;
            case ServiceStatus.loading:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.message);
              break;
            case ServiceStatus.success:
              setState(() {
                model = state.notifications;
              });
              break;
            case ServiceStatus.failure:
              ProgressHud.of(context)
                  .showAndDismiss(ProgressHudType.error, state.message);
              break;
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ClipPath(
        clipper: HalfCurveClipper(),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 36),
                ),
                SizedBox(height: 36),
                model?.newMatchNotication == null
                    ? Container()
                    : _buildNotificationTile(
                        title: "New Matches",
                        subtitle: "You matched with someone new",
                        value: model.newMatchNotication,
                        onChanged: (value) {
                          BlocProvider.of<NotificationBloc>(context)
                              .add(SetNewMatchNotificationEvent(value));
                        }),
                Divider(thickness: 1),
                SizedBox(height: 16),
                model?.messageNotification == null
                    ? Container()
                    : _buildNotificationTile(
                        title: "Messages",
                        subtitle: "Someone has sent you a message",
                        value: model.messageNotification,
                        onChanged: (value) {
                          BlocProvider.of<NotificationBloc>(context)
                              .add(SetMessageNotificationEvent(value));
                        }),
                SizedBox(height: 16),
                Divider(thickness: 1),
                model?.emailNotification == null
                    ? Container()
                    : _buildNotificationTile(
                        title: "Emails",
                        subtitle:
                            "I want to recieve news, updates and offers from YOPP",
                        value: model.emailNotification,
                        onChanged: (value) {
                          BlocProvider.of<NotificationBloc>(context)
                              .add(SetEmailNotificationEvent(value));
                        }),
              ],
            )),
      ),
    );
  }

  Widget _buildNotificationTile({
    @required String title,
    @required String subtitle,
    @required bool value,
    @required Function onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
            color: Hexcolor("#222222"),
            fontWeight: FontWeight.w600,
            fontSize: 15),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          subtitle,
          style: TextStyle(color: AppColors.lightGreen, fontSize: 14),
        ),
      ),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
