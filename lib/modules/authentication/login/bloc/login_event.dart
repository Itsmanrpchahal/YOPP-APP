import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginInitiateEvent extends LoginEvent {
  final bool remember;
  final String email;
  final String password;

  LoginInitiateEvent(this.email, this.password, [this.remember = false]);

  @override
  List<Object> get props => [remember, email, password];
}

class LoginInitialEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}
