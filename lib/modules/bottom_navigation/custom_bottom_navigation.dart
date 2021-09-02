import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

class CustomBottomNavigation extends StatefulWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;
  final int selectedIndex;
  final List<BottomNavigationBarItem> navigationItems;
  final void Function(int) onTap;

  const CustomBottomNavigation({
    Key key,
    this.padding,
    this.height,
    @required this.navigationItems,
    this.margin,
    @required this.selectedIndex,
    @required this.onTap,
  }) : super(key: key);
  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  final defaultMargin = const EdgeInsets.only(left: 20, right: 20, bottom: 20);
  final defaultPadding = const EdgeInsets.only(left: 32, right: 32, bottom: 32);
  final defaultHeight = 66.0;
  final shadowOffset = const Offset(0, 25);
  final shadowBlurRadius = 50.0;
  var selectedIndex = 0;
  final defaultAnimationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final margin = widget.margin ?? defaultMargin;
    // final padding = widget.padding ?? defaultPadding;
    final height = widget.height ?? defaultHeight;
    selectedIndex = widget.selectedIndex ?? selectedIndex;

    final navbarWidth = ((MediaQuery.of(context).size.width * 0.8) -
        margin.left -
        margin.right);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: height,
          margin: margin,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height / 10),
                topRight: Radius.circular(height / 2),
                bottomLeft: Radius.circular(height / 2),
                bottomRight: Radius.circular(height / 10),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: shadowOffset,
                    blurRadius: shadowBlurRadius)
              ]),
          child: Stack(
            children: [
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.navigationItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    BottomNavigationBarItem item =
                        widget.navigationItems[index];

                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        widget.onTap(index);
                      },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        width: index == widget.selectedIndex
                            ? navbarWidth / widget.navigationItems.length +
                                navbarWidth / 20
                            : navbarWidth / widget.navigationItems.length -
                                navbarWidth / 40,
                        duration: defaultAnimationDuration,
                        decoration: BoxDecoration(
                            color: index == widget.selectedIndex
                                ? AppColors.lightGrey.withOpacity(0.29)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: index == widget.selectedIndex
                                  ? Radius.circular(height / 2)
                                  : Radius.circular(0),
                              bottomLeft: index == widget.selectedIndex
                                  ? Radius.circular(height / 2)
                                  : Radius.circular(0),
                            )),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: index == widget.selectedIndex
                                  ? item.activeIcon
                                  : item.icon,
                            ),
                            Text(
                              item.label,
                              style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          )),
    );
  }
}
