import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/api_service.dart';

import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_sugession_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_suggestion.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_suggestion_event.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_suggestion_state.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar_with_cross.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/activity_sugession_service.dart';

class ActivitySuggestionsScreen extends StatefulWidget {
  static get route {
    return FadeRoute(builder: (context) {
      return BlocProvider<ActivitySugessionBloc>(
        create: (BuildContext context) => ActivitySugessionBloc(
            FirebaseActivitySugessionService(), APIProfileService()),
        child: ActivitySuggestionsScreen(),
      );
    });
  }

  @override
  _ActivitySuggestionsScreenState createState() =>
      _ActivitySuggestionsScreenState();
}

class _ActivitySuggestionsScreenState extends State<ActivitySuggestionsScreen> {
  List<ActivitySuggestion> suggestions = [];
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    loadLatestSuggestions(context);
    super.initState();
  }

  loadLatestSuggestions(BuildContext context) {
    print("load suggestion");
    BlocProvider.of<ActivitySugessionBloc>(context, listen: false)
        .add(GetLatestSuggestionList());
  }

  loadPreviousSuggestions(BuildContext context) {
    BlocProvider.of<ActivitySugessionBloc>(context, listen: false)
        .add(GetPreviousSuggestionList());
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      extendBodyBehindAppBar: false,
      appBar: TransparentAppBarWithCrossAction(
        context: context,
        onPressed: () {
          print("object");
          Navigator.of(context).pop();
        },
      ),
      body: BlocListener<ActivitySugessionBloc, ActivitySuggestionState>(
        listener: (context, state) async {
          print(state.status.toString());
          ProgressHud.of(context).dismiss();
          switch (state.status) {
            case ActivitySuggestionStatus.initial:
              break;
            case ActivitySuggestionStatus.loadingInitial:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.serviceMessage);
              break;
            case ActivitySuggestionStatus.loadingPrevious:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.serviceMessage);
              break;
            case ActivitySuggestionStatus.loadingInitialSuccess:
              break;
            case ActivitySuggestionStatus.loadingPreviousSuccess:
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
              break;
            case ActivitySuggestionStatus.failed:
              _refreshController.refreshCompleted();
              break;
            case ActivitySuggestionStatus.posting:
              break;
            case ActivitySuggestionStatus.posted:
              break;
          }

          setState(() {
            suggestions = state.suggestions;
          });
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading(context),
                SizedBox(height: 20),
                Expanded(child: _buildActivityList(context)),
              ],
            )),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    if (suggestions.isEmpty) {
      return _buildNoDataBackground(context);
    }
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      footer: ClassicFooter(
        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        idleIcon: Icon(
          Icons.refresh,
          color: Colors.black,
        ),
        loadingIcon: CupertinoActivityIndicator(),
        idleText: "Pull to Load More",
        failedText: "Failed to Load More",
        noDataText: "No Data",
        canLoadingText: "Release to Load More",
        loadingText: "Loading",
      ),
      onRefresh: () {},
      onLoading: () => loadPreviousSuggestions(context),
      onTwoLevel: () {},
      controller: _refreshController,
      child: ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];

            return _buildSuggestionsActivityItem(
                context: context, suggestion: suggestion);
          }),
    );
  }

  Widget _buildSuggestionsActivityItem({
    @required BuildContext context,
    @required ActivitySuggestion suggestion,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 18, right: 18, bottom: 8),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 40),
                blurRadius: 60,
                spreadRadius: 0)
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              suggestion?.title ?? "",
              style: TextStyle(
                  color: Hexcolor("#222222"),
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              suggestion.email,
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            SizedBox(height: 4),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                suggestion.userId ?? "",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
            SizedBox(height: 4),
            Text(
              suggestion.createdAt.toIso8601String(),
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Suggestions",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 36),
          ),
        ],
      ),
    );
  }

  _buildNoDataBackground(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: Offset(0, -60),
        child: Text(
          "No Suggestions Available",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
