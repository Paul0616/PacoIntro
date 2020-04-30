
import 'package:flutter/material.dart';

class ChevronNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 50,
      child: MaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
          // padding: EdgeInsets.all(16),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}