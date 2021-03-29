import 'package:flutter/material.dart';
import 'package:yopp/helper/animation/fade_animation.dart';
import 'package:yopp/modules/_common/sports/sports.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_card.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/activity_suggestion_screen.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/add_more_activity_card.dart';
import 'package:yopp/modules/screens.dart';

import 'package:yopp/widgets/app_bar/white_background_appbar.dart';

class SelectActivityScreen extends StatefulWidget {
  static Route route({SelectAbilityEnum isInitialSetupScreen}) =>
      MaterialPageRoute(
          builder: (_) => SelectActivityScreen(
                isInitialSetupScreen: isInitialSetupScreen,
              ));
  final SelectAbilityEnum isInitialSetupScreen;

  const SelectActivityScreen({Key key, @required this.isInitialSetupScreen})
      : super(key: key);

  @override
  _SelectActivityScreenState createState() => _SelectActivityScreenState();
}

class _SelectActivityScreenState extends State<SelectActivityScreen> {
  final newActivityController = TextEditingController();

  @override
  void dispose() {
    newActivityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: WhiteBackgroundAppBar(
        context: context,
        titleText: "Select Activity",
        showBackButton: Navigator.of(context).canPop(),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final paddingUnit = width / 33;
    final sports = getAllSports();

    return Padding(
      padding: EdgeInsets.all(paddingUnit / 2),
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: (sports.length + 1),
          // itemCount: (sports.length),
          itemBuilder: (context, index) {
            return FadeAnimation(
              delay: 0.05 * index,
              child: index == sports.length
                  ? AddMoreActivityCard(
                      paddingUnit: paddingUnit,
                      onTap: () => Navigator.of(context)
                          .push(ActivitySuggestionScreen.route))
                  : ActivityCard(
                      sport: sports[index],
                      paddingUnit: paddingUnit,
                      onTap: () => _selectDetails(context, sports[index]),
                    ),
            );
          }),
    );
  }

  _selectDetails(BuildContext context, Sport sport) {
    if (sport.subCategory.isEmpty && sport.styles.isEmpty) {
      Navigator.of(context).push(SelectAbilityScreen.route(
        userSport: UserSport(name: sport.name, sportId: sport.id),
        showtype: widget.isInitialSetupScreen,
      ));
    } else {
      Navigator.of(context).push(SelectCategoryScreen.route(
          sportId: sport.id,
          isInitialSetupScreen: widget.isInitialSetupScreen));
    }
  }
}
