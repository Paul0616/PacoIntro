import 'package:flutter/material.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/chevron_navigation.dart';

class TopBar extends StatelessWidget {
  final double bottomMargin;
  final bool withBackNavigation;

  const TopBar(
      {Key key, this.bottomMargin = 0, this.withBackNavigation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148.0,
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: pacoAppBarColor,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        topBarMiddleGap / 2,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        )),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      width: topBarMiddleGap,
                      decoration: BoxDecoration(
                          color: pacoAppBarColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        topBarMiddleGap / 2,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(top: 32.0, bottom: 16),
              child: Image.asset('images/logo.png', height: 100),
            ),
          ),
          withBackNavigation
              ? Positioned(top: 24, left: 0, child: ChevronNavigation())
              : Container(),
        ],
      ),
    );
  }
}
