import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_state.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/ui/users_profile_screen.dart';
import 'package:yopp/widgets/buttons/error_and_retry_widget.dart';
import 'package:yopp/widgets/icons/circular_profile_icon.dart';

import 'bloc/api_connection_data.dart';

class ConnectionsPage extends StatefulWidget {
  final Function onPullToRefresh;
  const ConnectionsPage({
    Key key,
    this.onPullToRefresh,
  }) : super(key: key);
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionsPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController refreshController;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    print("ConnectionsPage init");
    super.initState();
    refreshController = RefreshController();
    refreshPage(context);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  void refreshPage(BuildContext context) {
    if (mounted) {
      print("refresh Connection");
      context.read<ConnectionsBloc>().add(LoadConnectionEvent());
    }
  }

  void loadAnotherPage(BuildContext context) {
    if (mounted) {
      context.read<ConnectionsBloc>().add(LoadMoreConnectionEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ConnectionsBloc, ConnectionsState>(
        listener: (context, state) async {},
        builder: (context, state) {
          if (state.serviceStatus == ConnectionServiceStatus.loadingFailed) {
            return RetryWidget(onRetry: () => refreshPage(context));
          } else {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: SmartRefresher(
                controller: refreshController,
                enablePullUp: state.userConnection?.data?.isNotEmpty ?? false,
                onRefresh: () {
                  refreshController.refreshCompleted();
                  widget.onPullToRefresh();
                },
                onLoading: () {
                  print("onloading");
                  loadAnotherPage(context);
                },
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 32,
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final connectionData =
                              state.userConnection.data.elementAt(index);
                          final user = connectionData.user;

                          return InkWell(
                            onLongPress: () =>
                                showOptions(context, connectionData),
                            onTap: () => showOptions(context, connectionData),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ActiveCircularProfileIcon(
                                    size: MediaQuery.of(context).size.width / 8,
                                    imageUrl: user?.avatar ?? "",
                                    gender: user?.gender,
                                    isOnline: user?.online ?? false,
                                  ),
                                  SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _viewConnectionProfile(
                                      context,
                                      connectionData.user,
                                    ),
                                    child: Text(user?.name ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14)),
                                  ),
                                  SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      connectionData.interest,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.green, fontSize: 9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: state.userConnection?.data?.length ?? 0,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                      padding: EdgeInsets.only(bottom: 60, top: 32),
                      child: state.serviceStatus ==
                              ConnectionServiceStatus.loadingMore
                          ? Center(child: CircularProgressIndicator())
                          : Container(),
                    )),
                  ],
                ),
              ),
            );
          }
        });
  }

  _goToChatDetail(BuildContext context, ConnectionData connectionData) {
    context
        .read<ConnectionsBloc>()
        .add(ChatToConnectionEvent(connectionData: connectionData));
  }

  _viewConnectionProfile(BuildContext context, ConnectionUser user) async {
    await Navigator.of(context)
        .push(UserProfileScreen.route(userId: user.uid, userProfile: null));

    refreshPage(context);
  }

  void _deleteConnection(
      BuildContext context, String connectionId, String otherUserId) {
    context.read<ConnectionsBloc>().add(DeleteConnectionEvent(
        connectionId: connectionId,
        uids: [FirebaseAuth.instance.currentUser.uid, otherUserId]));
  }

  showOptions(BuildContext context, ConnectionData data) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 260,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.of(ctx).pop();
                  _goToChatDetail(context, data);
                },
                leading: Icon(Icons.edit),
                title: Text('Start Chatting '),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(ctx).pop();
                  _viewConnectionProfile(context, data.user);
                },
                leading: Icon(Icons.person),
                title: Text('View Profile '),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(ctx).pop();
                  _deleteConnection(
                    context,
                    data.connectionId,
                    data.user.uid,
                  );
                },
                leading: Icon(Icons.delete_forever),
                title: Text('Delete'),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(ctx).pop(null);
                },
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
