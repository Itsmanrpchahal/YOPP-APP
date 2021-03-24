import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender_event.dart';

class GenderBloc extends Bloc<BirthYearEvent, BaseState> {
  GenderBloc(this._service) : super(BaseState.inital());
  final ProfileService _service;

  @override
  Stream<BaseState> mapEventToState(BirthYearEvent event) async* {
    if (event is GenderSelectionEvent) {
      try {
        yield BaseState.loading(message: "Updating");
        await _service.saveGender(event.gender);

        yield BaseState.success(message: "Successfull");
      } catch (error) {
        yield BaseState.failure(message: error.toString());
      }
    }
    yield state;
  }
}
