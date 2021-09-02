import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/search_page.dart';

abstract class SearchRangeEvent extends Equatable {}

class SetSearchRangeEvent extends SearchRangeEvent {
  final SearchRange range;

  SetSearchRangeEvent(this.range);
  @override
  List<Object> get props => [range];
}

class LoadSelectedSearchRangeEvent extends SearchRangeEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
