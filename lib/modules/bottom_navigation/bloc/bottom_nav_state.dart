import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'bottom_nav_bloc.dart';

class BottomNavState extends Equatable {
  final BottomNavOption selectedOption;
  final TabBarOption tabOption;

  final DateTime selectedTime;
  BottomNavState({
    @required this.selectedOption,
    @required this.selectedTime,
    this.tabOption,
  });

  @override
  List<Object> get props => [selectedOption, selectedTime, tabOption];
}
