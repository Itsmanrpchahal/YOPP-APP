import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/search_page.dart';

class SearchRangeState extends Equatable {
  final int selectedId;
  final SearchRange selectedSerarchRange;
  final List<SearchRange> searchRanges;

  SearchRangeState(
      {@required this.selectedId,
      this.selectedSerarchRange,
      this.searchRanges});

  SearchRangeState copyWith({
    int selectedId,
    SearchRange selectedSerarchRange,
    List<SearchRange> searchRanges,
  }) {
    return SearchRangeState(
      selectedId: selectedId ?? this.selectedId,
      selectedSerarchRange: selectedSerarchRange ?? this.selectedSerarchRange,
      searchRanges: searchRanges ?? this.searchRanges,
    );
  }

  @override
  List<Object> get props => [searchRanges, selectedSerarchRange, selectedId];
}
