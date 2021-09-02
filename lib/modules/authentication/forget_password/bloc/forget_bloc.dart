import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_service.dart';
import 'package:yopp/modules/authentication/forget_password/bloc/forget_event.dart';

class ForgotBloc extends Bloc<ForgotEvent, BaseState> {
  ForgotBloc(this._service) : super(BaseState.inital());
  final BaseAuthService _service;

  @override
  Stream<BaseState> mapEventToState(ForgotEvent event) async* {
    if (event is ForgotPasswordEvent) {
      try {
        yield BaseState.loading(
            message: "Sending Reset Link to " + event.email);
        await _service.sendResetPassword(event.email);
        yield BaseState.success(
            message:
                "A password reset link has been sent to your email address.");
      } catch (error) {
        yield BaseState.failure(message: error.toString());
      }
    }
  }
}
