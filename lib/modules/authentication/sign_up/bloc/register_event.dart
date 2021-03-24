import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class RegisterScreenEvent {}

class RegisterEvent extends RegisterScreenEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String countryCode;

  RegisterEvent({
    @required this.name,
    this.countryCode,
    @required this.phone,
    @required this.email,
    @required this.password,
  });
}

class GotCountryNameEvent extends RegisterScreenEvent {
  final String countryName;

  GotCountryNameEvent({
    @required this.countryName,
  });
}
