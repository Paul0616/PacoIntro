import 'package:flutter/material.dart';
import 'package:pacointro/utils/constants.dart';

class SearchFieldWidget extends StatelessWidget {
  final String hint;
  final bool disabled;
  final Function onTap;
  final Function onChanged;
  final bool keyboardShouldBeNumeric;

  SearchFieldWidget(
      {this.hint,
      this.disabled,
      this.onTap,
      this.onChanged,
      this.keyboardShouldBeNumeric});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: textGray,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: onChanged,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: keyboardShouldBeNumeric
                      ? TextInputType.number
                      : TextInputType.text,
                  style: textStyle.copyWith(decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: hint,
                    hintStyle: textStyle,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: disabled ? null : onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              decoration: BoxDecoration(
                color: disabled ? pacoRedDisabledColor : pacoRedMaterialColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.search,
                color: disabled ? Colors.white38 : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
