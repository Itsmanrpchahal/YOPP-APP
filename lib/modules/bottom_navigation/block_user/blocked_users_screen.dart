import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/blocked_users.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/event.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';
import 'package:yopp/widgets/buttons/error_and_retry_widget.dart';
import 'package:yopp/widgets/icons/circular_profile_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'bloc/bloc.dart';

class BlockedUsersScreen extends StatefulWidget {
  static Route route({
    Key key,
  }) {
    return FadeRoute(builder: (_) => BlockedUsersScreen());
  }

  @override
  _BlockedUsersScreenState createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  RefreshController refreshController;

  @override
  void initState() {
    print("BlockedUsersScreen init");
    super.initState();
    refreshController = RefreshController();
    refreshPage(context);
  }

  void refreshPage(BuildContext context) {
    context.read<BlockedUserBloc>().add(LoadBlockedUserEvent());
  }

  void loadAnotherPage(BuildContext context) {
    context.read<BlockedUserBloc>().add(LoadMoreBlockedUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        appBar: new DefaultAppBar(context: context, titleText: "Blocked Users"),
        body: BlocConsumer<BlockedUserBloc, BlockState>(
            listener: (context, state) async {
          print(state.status);
          ProgressHud.of(context)?.dismiss();
          switch (state.status) {
            case BlockServiceStatus.initial:
              break;
            case BlockServiceStatus.loading:
              ProgressHud.of(context).showLoading(text: state.serviceMessage);
              break;
            case BlockServiceStatus.loaded:
              break;
            case BlockServiceStatus.loadingMore:
              break;
            case BlockServiceStatus.loadedMore:
              break;
            case BlockServiceStatus.loadingMoreFailed:
              break;
            case BlockServiceStatus.blocking:
              ProgressHud.of(context).showLoading(text: state.serviceMessage);
              break;
            case BlockServiceStatus.blocked:
              refreshPage(context);
              break;
            case BlockServiceStatus.unblocking:
              ProgressHud.of(context).showLoading(text: state.serviceMessage);

              break;
            case BlockServiceStatus.unblocked:
              await ProgressHud.of(context)
                  .showSuccessAndDismiss(text: state.serviceMessage);
              // refreshPage(context);
              break;
            case BlockServiceStatus.loadingFailed:
              await ProgressHud.of(context)
                  .showErrorAndDismiss(text: state.serviceMessage);
              break;
            case BlockServiceStatus.blockingFailed:
              await ProgressHud.of(context)
                  .showErrorAndDismiss(text: state.serviceMessage);
              break;
            case BlockServiceStatus.unblockingFailed:
              await ProgressHud.of(context)
                  .showErrorAndDismiss(text: state.serviceMessage);
              break;
          }
        }, builder: (context, state) {
          if (state.status == BlockServiceStatus.loadingFailed) {
            return RetryWidget(onRetry: () => refreshPage(context));
          } else {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: SmartRefresher(
                  controller: refreshController,
                  enablePullUp: state.blockedUsers?.isNotEmpty ?? false,
                  onRefresh: () {
                    refreshController.refreshCompleted();
                    refreshPage(context);
                  },
                  onLoading: () {
                    print("onloading");
                    loadAnotherPage(context);
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.blockedUsers.length,
                      itemBuilder: (context, index) {
                        final user = state.blockedUsers.elementAt(index);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                                leading: CircularProfileIconWithShadow(
                                    gender: user.gender, imageUrl: user.avatar),
                                title: Text(user?.name ?? ""),
                                trailing: FlatButton(
                                  color: AppColors.green,
                                  onPressed: () =>
                                      _unblockUser(context, user: user),
                                  child: Text("Unblock",
                                      style: TextStyle(color: Colors.white)),
                                )),
                            Divider(),
                            state.status == BlockServiceStatus.loadedMore
                                ? Container(
                                    height: 100,
                                    padding:
                                        EdgeInsets.only(bottom: 32, top: 32),
                                    child: Center(
                                        child: CircularProgressIndicator()))
                                : Container(),
                          ],
                        );
                      })),
            );
          }
        }),
      ),
    );
  }

  _unblockUser(BuildContext context, {@required BlockedUser user}) {
    context.read<BlockedUserBloc>().add(UnblockUserEvent(
        friendId: user.id,
        friendUid: user.uid,
        myId: context.read<ProfileBloc>().state.userProfile.id,
        myUid: context.read<ProfileBloc>().state.userProfile.uid));
  }
}
