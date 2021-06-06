import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/bottom_navigation/filter/filter_dialog.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/about/height_bottom_sheet.dart';

import 'package:yopp/widgets/textfield/auth_field.dart';

import 'ability_listview.dart';

class AboutPage extends StatefulWidget {
  final Function onPullToRefresh;

  const AboutPage({Key key, @required this.onPullToRefresh}) : super(key: key);
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  RefreshController refreshController;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    print("initState - ");
    refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkForUserUpdate(BuildContext context) {
    print("About page checkForUserUpdate");
    BlocProvider.of<ProfileBloc>(context, listen: false).add(
        LoadUserProfileEvent(userId: FirebaseAuth.instance.currentUser.uid));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("about_screen_build");
    return BlocConsumer<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () {
              widget.onPullToRefresh();
              refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      _buildAboutText(state?.userProfile?.about),
                      _buildProfileRow(
                          height: state?.userProfile?.height,
                          age: state?.userProfile?.age,
                          selectedInterest:
                              state?.userProfile?.selectedInterest),
                      _buildAbilitySection(
                          context,
                          state?.userProfile?.interests,
                          state.userProfile?.selectedInterest),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget _buildAboutText(String text) {
    return Container(
      child: InkWell(
        onTap: () {
          _showAboutBottomSheet(context, text);
        },
        child: Text(
          (text != null && text.isNotEmpty) ? text : DefaultText.ABOUT_USER,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.green,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  _buildProfileRow({
    @required int height,
    @required int age,
    @required Interest selectedInterest,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              HeightBottomSheet.show(context, height?.toString() ?? null);
            },
            child: Column(
              children: [
                height == null
                    ? _buildTitleTextWidget("Add")
                    : _buildTitleTextWidget(height.toStringAsFixed(0) + " cm"),
                SizedBox(height: 4),
                _buildSubtitleTextWidget("Height"),
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showAgeDatePicker(context),
            child: Column(
              children: [
                age == null
                    ? _buildTitleTextWidget("Add")
                    : _buildTitleTextWidget(age.toString()),
                SizedBox(height: 4),
                _buildSubtitleTextWidget("Age"),
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (selectedInterest == null) {
                _addInterest(context);
              } else {
                _editInterest(context, selectedInterest);
              }
            },
            child: Column(
              children: [
                selectedInterest == null
                    ? _buildTitleTextWidget("Add")
                    : _buildTitleTextWidget(
                        selectedInterest?.skill?.name ?? ""),
                SizedBox(height: 4),
                _buildSubtitleTextWidget("Skill Level"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitySection(
    BuildContext context,
    List<Interest> interests,
    Interest selectedInterest,
  ) {
    return Container(
      child: AbilityListView(
        interests: interests ?? [],
        selectedInterest: selectedInterest,
        onAddingNewSport: () {},
      ),
    );
  }

  _buildSubtitleTextWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.green,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  _buildTitleTextWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColors.green,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Future<void> _showAgeDatePicker(BuildContext context) async {
    final minDate = DateTime.now().subtract(Duration(days: 365 * 100));
    final maxDate = DateTime.now().subtract(Duration(days: 365 * 13));

    DateTime birthDate = minDate;
    final profile = context.read<ProfileBloc>().state.userProfile;
    print(birthDate.toIso8601String());
    if (profile?.birthDate != null) {
      birthDate = profile.birthDate;
    } else if (profile?.dob != null) {
      birthDate = DateTime(profile.dob);
    }

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3 + 60,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: birthDate,
                        minimumYear: minDate.year,
                        minimumDate: minDate,
                        maximumYear: maxDate.year,
                        maximumDate: maxDate,
                        onDateTimeChanged: (date) {
                          print(date.year.toString());
                          setState(() {
                            if (date != null) {
                              birthDate = date;
                            }
                          });
                        }),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: FlatButton(
                        color: AppColors.green,
                        height: 50,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<ProfileBloc>(context).add(
                            UpdateUserProfileEvent(
                              profile: UserProfile(
                                  birthDate: birthDate, dob: birthDate.year),
                            ),
                          );
                        },
                        child: Text(
                          "CONFIRM",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ))
                ]),
          );
        });
  }

  _showAboutBottomSheet(BuildContext context, String about) {
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
                      numberOfLines: 5,
                      placeHolderText: "Few words about me",
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return value.length > 0
                            ? null
                            : "Enter few words about you.";
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
                                  profile:
                                      UserProfile(about: controller.text)));
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

  _addInterest(BuildContext context) async {
    final availableInterest =
        BlocProvider.of<ProfileBloc>(context, listen: false)
            .state
            .interestOptions;
    final interestToBeUpdate = await InterestDialog.show(
      context,
      availableInterests: availableInterest,
      interest: null,
    );

    if (interestToBeUpdate != null) {
      context
          .read<ProfileBloc>()
          .add(AddNewInterestEvent(interest: interestToBeUpdate));
    }
  }

  _editInterest(BuildContext context, Interest interest) async {
    final availableInterest =
        BlocProvider.of<ProfileBloc>(context, listen: false)
            .state
            .interestOptions;

    final interestToBeUpdate = await InterestDialog.show(
      context,
      availableInterests: availableInterest,
      interest: interest,
    );

    if (interestToBeUpdate != null) {
      context
          .read<ProfileBloc>()
          .add(UpdatePreferedInterestEvent(interest: interestToBeUpdate));
    }
  }
}
