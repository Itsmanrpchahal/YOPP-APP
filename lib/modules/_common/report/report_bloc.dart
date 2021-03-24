import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/_common/report/report_event.dart';
import 'package:yopp/modules/_common/report/report_service.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';

class ReportBloc extends Bloc<ReportEvent, BaseState> {
  ReportBloc(this._service, this._preferenceService)
      : super(BaseState.inital());

  final ReportService _service;
  final PreferenceService _preferenceService;

  @override
  Stream<BaseState> mapEventToState(ReportEvent event) async* {
    if (event is ReportEvent) {
      try {
        yield BaseState.loading(message: "Reporting");
        final profile = await _preferenceService.getUserProfile();
        await _service.reportUser(profile.id, event.reportTo, event.title,
            event.subject, event.description);
        yield BaseState.success(message: "Reported");
      } catch (error) {
        yield BaseState.failure(message: error.toString());
      }
    }

    yield state;
  }
}
