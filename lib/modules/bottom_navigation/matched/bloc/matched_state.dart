import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

class MatchedState extends Equatable {
  final ServiceStatus status;
  final String message;
  final ChatDescription chatDescription;

  const MatchedState._({
    this.status = ServiceStatus.initial,
    this.message = "",
    this.chatDescription,
  });

  const MatchedState.inital()
      : this._(status: ServiceStatus.initial, message: "");

  const MatchedState.loading({String message})
      : this._(status: ServiceStatus.loading, message: message ?? "");

  const MatchedState.success({String message, ChatDescription chatDescription})
      : this._(
          status: ServiceStatus.success,
          message: message ?? "",
          chatDescription: chatDescription,
        );

  const MatchedState.failure({String message})
      : this._(status: ServiceStatus.failure, message: message ?? "");

  @override
  List<Object> get props => [status, message];
}
