import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/_common/report/report_event.dart';
import 'package:yopp/modules/_common/report/report_service.dart';

class ReportBloc extends Bloc<ReportEvent, BaseState> {
  ReportBloc(this._service) : super(BaseState.inital());

  final ReportService _service;

  @override
  Stream<BaseState> mapEventToState(ReportEvent event) async* {
    if (event is ReportEvent) {
      try {
        yield BaseState.loading(message: "Reporting");
        await _service.reportUser(event.reportBy, event.reportTo, event.title,
            event.subject, event.description);
        yield BaseState.success(message: "Reported");
      } catch (error) {
        yield BaseState.failure(message: error.toString());
      }
    }

    yield state;
  }
}
