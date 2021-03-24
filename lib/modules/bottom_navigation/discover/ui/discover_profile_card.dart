import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/icons/default_user_icon.dart';

class DiscoverProfileCard extends StatelessWidget {
  const DiscoverProfileCard({
    Key key,
    @required this.padding,
    @required this.discoverdUser,
    @required this.height,
    @required this.distance,
    @required this.iconString,
  }) : super(key: key);

  final double padding;
  final DiscoveredUser discoverdUser;
  final double height;
  final int distance;
  final String iconString;

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(padding / 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 34.3,
                  offset: Offset(0, 25))
            ]),
        child: Stack(
          children: [
            discoverdUser.avatar == null || discoverdUser.avatar.isEmpty
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black38,
                    child: discoverdUser.gender == Gender.male
                        ? MaleIcon()
                        : FemaleIcon(),
                  )
                : CachedNetworkImage(
                    imageUrl: discoverdUser?.avatar ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black38, BlendMode.darken),
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  discoverdUser.name,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              right: height / 36,
              top: height / 36,
              child: CircleAvatar(
                radius: height / 12,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  iconString,
                  fit: BoxFit.cover,
                  width: height / 10,
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        distance.toString() + "km away",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      // discoverdUser?.selectedSport?.weightRequired == false
                      //     ? Container()
                      //     : Text(
                      //         discoverdUser.weight.toInt().toString() + "kg",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      // discoverdUser?.selectedSport?.heightRequired == false
                      //     ? Container()
                      //     : Text(
                      //         discoverdUser.height.toInt().toString() + "cm",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
