import 'package:equatable/equatable.dart';

enum ServiceStatus { initial, loading, success, failure }

class BaseState extends Equatable {
  final ServiceStatus status;
  final String message;

  const BaseState._({
    this.status = ServiceStatus.initial,
    this.message = "",
  });

  const BaseState.inital() : this._(status: ServiceStatus.initial, message: "");

  const BaseState.loading({String message})
      : this._(status: ServiceStatus.loading, message: message ?? "");

  const BaseState.success({String message})
      : this._(status: ServiceStatus.success, message: message ?? "");

  const BaseState.failure({String message})
      : this._(status: ServiceStatus.failure, message: message ?? "");

  @override
  List<Object> get props => [status, message];
}
