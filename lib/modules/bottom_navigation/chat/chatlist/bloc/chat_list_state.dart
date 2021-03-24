import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

class ChatHistoryState extends Equatable {
  final ServiceStatus status;
  final String message;
  final List<ChatDescription> history;
  final currentUserId;

  const ChatHistoryState._({
    this.status = ServiceStatus.initial,
    this.message = "",
    this.currentUserId = "",
    this.history = const [],
  });

  const ChatHistoryState.inital()
      : this._(status: ServiceStatus.initial, message: "");

  const ChatHistoryState.loading({String message})
      : this._(status: ServiceStatus.loading, message: message ?? "");

  const ChatHistoryState.success({
    String message,
    List<ChatDescription> history,
    String currentUserId,
  }) : this._(
            status: ServiceStatus.success,
            message: message ?? "",
            history: history,
            currentUserId: currentUserId ?? "");

  const ChatHistoryState.failure({String message})
      : this._(status: ServiceStatus.failure, message: message ?? "");

  @override
  List<Object> get props => [status, message, history];
}
