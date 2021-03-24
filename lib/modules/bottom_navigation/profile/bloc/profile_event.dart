import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {}

class GetUserProfile extends ProfileEvent {
  final String userId;

  GetUserProfile({
    this.userId,
  });

  @override
  List<Object> get props => [userId];
}
