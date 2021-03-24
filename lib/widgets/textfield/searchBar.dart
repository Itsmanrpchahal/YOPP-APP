import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ValueCallBack = Function(String);

class SearchBar extends StatefulWidget {
  final String initialValue;
  final ValueCallBack onChange;

  const SearchBar({
    Key key,
    this.initialValue,
    @required this.onChange,
  }) : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  clearSearchBar() {
    setState(() {
      _searchBarController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _searchBarController,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (value) {
          widget.onChange(value);
          setState(() {});
        },
        onSubmitted: (keyword) {
          if (keyword.isNotEmpty) {
            widget.onChange(keyword);
          }
        },
        maxLines: 1,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.only(
            bottom: 18,
          ),
          labelText: 'Search for...',
          alignLabelWithHint: false,
          labelStyle: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              CupertinoIcons.search,
              size: 30,
              color: Colors.white54,
            ),
          ),
          suffixIcon: _searchBarController.text.isEmpty
              ? Container(
                  width: 0,
                )
              : IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 30,
                  ),
                  color: Colors.white54,
                  onPressed: () {
                    _searchBarController.clear();
                    widget.onChange(_searchBarController.text);
                  }),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
