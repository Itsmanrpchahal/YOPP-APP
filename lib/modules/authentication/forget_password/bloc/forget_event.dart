import 'package:equatable/equatable.dart';

abstract class ForgotEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordEvent extends ForgotEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}
