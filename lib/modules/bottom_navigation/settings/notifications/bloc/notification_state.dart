import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/base_view_model.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_setting.dart';

class NotificationState extends Equatable {
  final NotificationSetting notifications;
  final String message;

  final ServiceStatus status;

  NotificationState({
    this.notifications = const NotificationSetting(
        emailNotification: true,
        newMatchNotication: true,
        messageNotification: true),
    this.status = ServiceStatus.none,
    this.message = "",
  });

  NotificationState copyWith({
    NotificationSetting notifications,
    String message,
    ServiceStatus status,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [notifications, message, status];
}
