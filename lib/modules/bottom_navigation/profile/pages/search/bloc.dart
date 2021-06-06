import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/event.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/search_page.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/state.dart';

List<SearchRange> get availableRangesList {
  return [
    SearchRange(id: 0, name: "10 km", distance: 10000.0),
    SearchRange(id: 1, name: "20 km", distance: 20000.0),
    SearchRange(id: 2, name: "30 km", distance: 30000.0),
    SearchRange(id: 3, name: "40 km", distance: 40000.0),
    SearchRange(id: 4, name: "50 km", distance: 50000.0),
    SearchRange(id: 5, name: "100 km", distance: 100000.0),
    SearchRange(id: 6, name: "200 km", distance: 200000.0),
    SearchRange(id: 7, name: "300 km", distance: 300000.0),
    SearchRange(id: 8, name: "500+ km", distance: 50000000.0),
  ];
}

class SearchRangeBloc extends Bloc<SearchRangeEvent, SearchRangeState> {
  SearchRangeBloc()
      : super(
            SearchRangeState(selectedId: 4, searchRanges: availableRangesList));

  @override
  Stream<SearchRangeState> mapEventToState(SearchRangeEvent event) async* {
    if (event is SetSearchRangeEvent) {
      try {
        await _selectRange(event.range);
        add(LoadSelectedSearchRangeEvent());
      } catch (error) {}
    }
    if (event is LoadSelectedSearchRangeEvent) {
      try {
        final rangeId = await _getSelectedRangeId();
        if (rangeId != null) {
          SearchRange range =
              state.searchRanges.firstWhere((element) => element.id == rangeId);
          yield state.copyWith(
              selectedId: rangeId, selectedSerarchRange: range);
        }
      } catch (error) {}
    }

    yield state;
  }

  Future<void> _selectRange(SearchRange range) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("SearchRangeIndex", range.id);
  }

  Future<int> _getSelectedRangeId() async {
    final prefs = await SharedPreferences.getInstance();
    var rangeId = prefs.getInt("SearchRangeIndex") ?? 4;
    return rangeId;
  }
}
