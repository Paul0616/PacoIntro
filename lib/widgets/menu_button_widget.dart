
import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  final Image image;
  final Text text;
  final Function onTap;

  const MenuButtonWidget({
    Key key,
    this.image,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: onTap,
                      child: Card(
                        elevation: 10,
                        shape: CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: CircleAvatar(
                          radius: 52,
                          child: CircleAvatar(
                            //backgroundColor:
                            //freyaProductBackgroundDefault,
                            radius: 50,
                            child: Container(
                              width: 70,
                              child: image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    text,
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}