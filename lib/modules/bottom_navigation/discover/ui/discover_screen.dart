import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/helper/url_constants.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_bloc.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_event.dart';

import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_state.dart';
import 'package:yopp/modules/bottom_navigation/discover/ui/discover_page.dart';
import 'package:yopp/modules/bottom_navigation/filter/filter_dialog.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

import 'package:yopp/modules/bottom_navigation/profile/pages/search/bloc.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import '../bloc/discover_event.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({
    Key key,
  }) : super(key: key);
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController _tabController;

  Interest selectedInterest;

  @override
  void initState() {
    print("DiscoverScreen  init");
    selectedInterest =
        context.read<ProfileBloc>().state.userProfile.selectedInterest;
    _tabController = TabController(length: 3, initialIndex: 2, vsync: this);

    _refreshCards(
      context,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshCards(
    BuildContext context,
  ) {
    print("_refreshCards");

    SearchBy searchBy;

    if (_tabController.index == 0 || _tabController.index == 1) {
      searchBy = SearchBy.interest;
    } else {
      if (selectedInterest?.subCategory != null) {
        searchBy = SearchBy.subCategory;
      } else if (selectedInterest?.category != null) {
        searchBy = SearchBy.category;
      } else if (selectedInterest?.interest != null) {
        searchBy = SearchBy.interest;
      }
    }

    print("searchBy:" + searchBy.toString());
    print(_tabController.index == 1);
    BlocProvider.of<DiscoverBloc>(context, listen: false).add(
      DiscoverUsersEvent(
        showOnlineOnly: _tabController.index == 1,
        currentUser: context.read<ProfileBloc>().state.userProfile,
        selectedInterest: selectedInterest,
        searchBy: searchBy,
        searchRange: context.read<SearchRangeBloc>().state.selectedSerarchRange,
      ),
    );
  }

  void refineInterest(BuildContext context) async {
    final availableInterest =
        BlocProvider.of<ProfileBloc>(context, listen: false)
            .state
            .interestOptions;

    final interestToBeUpdate = await InterestDialog.show(
      context,
      availableInterests: availableInterest,
      interest: selectedInterest,
      refineFilter: true,
    );

    if (interestToBeUpdate != null) {
      print("interestToBeUpdate");
      print(interestToBeUpdate.toJson().toString());

      setState(() {
        selectedInterest = interestToBeUpdate;
      });

      _refreshCards(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = (MediaQuery.of(context).size.height / 3);
    final tabBarHeight = 80.0;

    var availableWithin = "Within " +
        context.watch<SearchRangeBloc>().state.selectedSerarchRange.name;

    String interestImageUrl = "";
    String categoryImageUrl = "";
    final interestsOptions = context.watch<ProfileBloc>().state.interestOptions;

    interestsOptions.forEach((interestOption) {
      if (interestOption.id == selectedInterest.interest.id) {
        interestImageUrl = UrlConstants.interestImageUrl(interestOption.image);
        categoryImageUrl = UrlConstants.interestImageUrl(interestOption.image);

        interestOption.category.forEach((categoryOption) {
          if (categoryOption.id == selectedInterest.category.id) {
            print(categoryOption.toRawJson());
            categoryImageUrl =
                UrlConstants.discoverCategoryImageUrl(categoryOption.image);
          }
        });
      }
    });

    return ProgressHud(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: new MenuAppBar(
            context: context,
            titleText: "Discover",
          ),
          body: BlocConsumer<DiscoverBloc, DiscoverState>(
            listener: (context, state) async {
              print(state.status.toString());
              ProgressHud.of(context)?.dismiss();
              switch (state.status) {
                case DiscoverServiceStatus.initial:
                  break;
                case DiscoverServiceStatus.noLocation:
                  break;
                case DiscoverServiceStatus.loading:
                  ProgressHud.of(context)?.showLoading(text: state.message);
                  break;
                case DiscoverServiceStatus.loaded:
                  break;
                case DiscoverServiceStatus.loadingFailed:
                  await ProgressHud.of(context)
                      ?.showErrorAndDismiss(text: state.message);
                  break;
                case DiscoverServiceStatus.loadingAnotherPage:
                  break;
                case DiscoverServiceStatus.loadedAnotherPage:
                  break;
                case DiscoverServiceStatus.loadingAnotherPageFailed:
                  break;
              }
            },
            builder: (contex, state) {
              return Container(
                child: NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverAppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          floating: false,
                          shadowColor: Colors.black12,
                          toolbarHeight: 0,
                          expandedHeight: 0,
                          bottom: PreferredSize(
                            preferredSize:
                                Size(double.infinity, height + tabBarHeight),
                            child: Container(
                              height: height + tabBarHeight,
                              padding: EdgeInsets.zero,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildProfileImageSection(
                                    context,
                                    height: height,
                                    title: _tabController?.index == 2
                                        ? selectedInterest?.getInterestName() ??
                                            ""
                                        : selectedInterest?.interest?.name ??
                                            "",
                                    subtitle: "Available " + availableWithin,
                                    imageUrl: _tabController?.index == 2
                                        ? categoryImageUrl
                                        : interestImageUrl,
                                  ),
                                  // Container(

                                  Container(
                                    height: tabBarHeight,
                                    child: TabBar(
                                      controller: _tabController,
                                      onTap: (index) {
                                        print("ontap:" + index.toString());

                                        _refreshCards(context);
                                      },
                                      indicatorWeight: 1,
                                      tabs: [
                                        Container(
                                          height: tabBarHeight,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 0),
                                          child: Tab(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                state?.interestCount != null
                                                    ? state.interestCount
                                                        .toString()
                                                    : "",
                                                style: TextStyle(
                                                  color: AppColors.green,
                                                  fontSize: 18,
                                                ),
                                              )),
                                              Expanded(
                                                child: Text(
                                                  availableWithin,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppColors.green,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Container(
                                          height: tabBarHeight,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 0),
                                          child: Tab(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Text(
                                                  state?.availableCount != null
                                                      ? state.availableCount
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                    color: AppColors.green,
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )),
                                              Expanded(
                                                child: Text(
                                                  "Available Now",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppColors.green,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Container(
                                          height: tabBarHeight,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 0),
                                          child: Tab(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Container(
                                                child: Text(
                                                  state?.specificCount != null
                                                      ? state.specificCount
                                                          .toString()
                                                      : "",
                                                  style: TextStyle(
                                                    color: AppColors.green,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              )),
                                              Flexible(
                                                child: InkWell(
                                                  onTap: () =>
                                                      refineInterest(context),
                                                  child: Container(
                                                    padding: EdgeInsets.all(0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Refine Filter",
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .green,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: AppColors
                                                                .lightGreen,
                                                            size: 30,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      DiscoverPage(
                        onRefresh: () {
                          _refreshCards(context);
                        },
                      ),
                      DiscoverPage(
                        onRefresh: () {
                          _refreshCards(context);
                        },
                      ),
                      DiscoverPage(
                        onRefresh: () {
                          _refreshCards(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildProfileImageSection(BuildContext context,
      {String title, String subtitle, String imageUrl, double height = 200}) {
    print("imageUrl: " + imageUrl);
    return InkWell(
      onTap: () {},
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.lightGrey,
        child: Stack(
          children: [
            Transform.scale(
              scale: 1.2,
              alignment: Alignment.bottomCenter,
              child: CachedNetworkImage(
                  key: new ValueKey<String>(imageUrl),
                  imageUrl: imageUrl ?? "",
                  imageBuilder: (context, imageProvider) => Container(
                        height: height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                        height: height,
                      )),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Hexcolor("##030303").withOpacity(0.7),
                    Colors.transparent
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      context.read<BottomNavBloc>().add(BottomNavEvent(
                          navOption: BottomNavOption.profile,
                          tabOption: TabBarOption.second));
                    },
                    child: Text(subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
