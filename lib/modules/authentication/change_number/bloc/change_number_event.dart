import 'package:equatable/equatable.dart';

abstract class ChangeNumberEvent extends Equatable {}

class UpdateNumberEvent extends ChangeNumberEvent {
  final String countryCode;
  final String phoneNumber;

  UpdateNumberEvent(this.countryCode, this.phoneNumber);

  @override
  List<Object> get props => [countryCode, phoneNumber];
}
