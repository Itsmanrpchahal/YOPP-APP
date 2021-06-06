import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_event.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_state.dart';

enum BottomNavOption { profile, discover, connections }
enum TabBarOption { first, second, third }

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc(BottomNavState initialState) : super(initialState);

  @override
  Stream<BottomNavState> mapEventToState(BottomNavEvent event) async* {
    yield new BottomNavState(
      selectedOption: event.navOption,
      selectedTime: DateTime.now(),
      tabOption: event.tabOption,
    );
  }
}
