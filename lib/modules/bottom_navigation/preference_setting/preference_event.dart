import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PreferenceEvent extends Equatable {}

class ResetPreferenceEvent extends PreferenceEvent {
  @override
  List<Object> get props => [];
}

class GetPreferenceEvent extends PreferenceEvent {
  @override
  List<Object> get props => [];
}

class UpdatePreferenceEvent extends PreferenceEvent {
  final RangeValues ageRange;

  final double distance;

  UpdatePreferenceEvent({
    this.ageRange,
    this.distance,
  });
  @override
  List<Object> get props => [ageRange, distance];
}
