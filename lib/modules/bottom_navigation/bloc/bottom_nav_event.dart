import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'bottom_nav_bloc.dart';

class BottomNavEvent extends Equatable {
  final BottomNavOption navOption;
  final TabBarOption tabOption;
  BottomNavEvent({
    @required this.navOption,
    this.tabOption,
  });

  @override
  List<Object> get props => [navOption, tabOption];
}
