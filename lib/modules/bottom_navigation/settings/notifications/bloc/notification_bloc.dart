import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/base_view_model.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_event.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_service.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _service;
  NotificationBloc(this._service) : super(NotificationState());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is GetNotificationOptions) {
      try {
        yield state.copyWith(status: ServiceStatus.loading, message: "Loading");
        final model = await _service.getNotificationOptions();
        yield state.copyWith(
          status: ServiceStatus.success,
          message: "",
          notifications: model,
        );
      } catch (error) {
        yield state.copyWith(
            message: error.toString(), status: ServiceStatus.failure);
      }
    }

    if (event is SetEmailNotificationEvent) {
      try {
        yield state.copyWith(
            status: ServiceStatus.loading, message: "Updating");
        await _service.setEmailNotification(event.value);
        final updatedModel =
            state.notifications.copyWith(emailNotification: event.value);
        yield state.copyWith(
          status: ServiceStatus.success,
          message: "Updated",
          notifications: updatedModel,
        );
      } catch (error) {
        yield state.copyWith(
            message: error.toString(), status: ServiceStatus.failure);
      }
    }

    if (event is SetNewMatchNotificationEvent) {
      try {
        yield state.copyWith(
            status: ServiceStatus.loading, message: "Updating");
        await _service.setMatchNotification(event.value);
        final updatedModel =
            state.notifications.copyWith(newMatchNotication: event.value);
        yield state.copyWith(
          status: ServiceStatus.success,
          message: "Updated",
          notifications: updatedModel,
        );
      } catch (error) {
        yield state.copyWith(
            message: error.toString(), status: ServiceStatus.failure);
      }
    }

    if (event is SetMessageNotificationEvent) {
      try {
        yield state.copyWith(
            status: ServiceStatus.loading, message: "Updating");
        await _service.setMessageNotification(event.value);
        final updatedModel =
            state.notifications.copyWith(messageNotification: event.value);
        yield state.copyWith(
          status: ServiceStatus.success,
          message: "Updated",
          notifications: updatedModel,
        );
      } catch (error) {
        yield state.copyWith(
            message: error.toString(), status: ServiceStatus.failure);
      }
    }
  }
}
