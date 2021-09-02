import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {}

class GetNotificationOptions extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class SetNewMatchNotificationEvent extends NotificationEvent {
  final bool value;
  SetNewMatchNotificationEvent(this.value);
  @override
  List<Object> get props => [this.value];
}

class SetMessageNotificationEvent extends NotificationEvent {
  final bool value;
  SetMessageNotificationEvent(this.value);
  @override
  List<Object> get props => [this.value];
}

class SetEmailNotificationEvent extends NotificationEvent {
  final bool value;
  SetEmailNotificationEvent(this.value);
  @override
  List<Object> get props => [this.value];
}
