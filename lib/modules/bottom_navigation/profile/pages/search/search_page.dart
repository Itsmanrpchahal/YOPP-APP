import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/state.dart';

import 'event.dart';

class SearchRange {
  final int id;
  final String name;
  final double distance;
  var isSelected = false;

  SearchRange({
    @required this.id,
    @required this.name,
    @required this.distance,
    this.isSelected = false,
  });
}

class SearchPage extends StatefulWidget {
  final Function onChange;

  const SearchPage({Key key, this.onChange}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SearchRangeBloc, SearchRangeState>(
        builder: (context, state) {
      return GridView.count(
        padding: EdgeInsets.all(10),
        childAspectRatio: 1.2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(state.searchRanges.length, (index) {
          final item = state.searchRanges.elementAt(index);
          return InkWell(
            onTap: () {
              BlocProvider.of<SearchRangeBloc>(context)
                  .add(SetSearchRangeEvent(item));
              if (widget.onChange != null) {
                widget.onChange();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(color: AppColors.green, fontSize: 18),
                ),
                Radio(
                  value: item.id,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  groupValue: state.selectedId,
                  onChanged: (index) async {
                    BlocProvider.of<SearchRangeBloc>(context)
                        .add(SetSearchRangeEvent(item));
                    if (widget.onChange != null) {
                      widget.onChange();
                    }
                  },
                  activeColor: AppColors.green,
                  hoverColor: AppColors.green,
                  focusColor: AppColors.green,
                ),
                Text(
                  item.isSelected ? "Active" : "Select",
                  style: TextStyle(color: AppColors.green),
                ),
                Spacer()
              ],
            ),
          );
        }),
      );
    });
  }
}
