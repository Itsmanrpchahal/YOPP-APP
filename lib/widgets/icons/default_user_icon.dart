import 'package:flutter/widgets.dart';

import 'package:flutter_svg/svg.dart';

class MaleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/male_user.svg',
    );
  }
}

class FemaleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/icons/female_user.svg');
  }
}
