import 'package:flutter/material.dart';
import 'package:recommendation/Utils/MainColors.dart';

import 'Fonts.dart';
import 'TextStyle.dart';

class TextFieldStyle {
  primaryTextField(String text, Icon icon, Color color) {
    return InputDecoration(
      labelText: text,
      prefixIcon: icon,
      prefixIconColor: color,
      labelStyle: TextStyle(
        fontFamily: Fonts.PrimaryFont,
        fontSize: 16,
        color: Colors.white60,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1, color: color.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.8)),
      ),
    );
  }

  SecondTextField(String text, Icon icon, Color color) {
    return InputDecoration(
      labelText: text,
      prefixIcon: icon,
      prefixIconColor: color,
      labelStyle: TextStyle(
        fontFamily: Fonts.PrimaryFont,
        fontSize: 16,
        color: MainColors.mainColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1, color: color.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.8)),
      ),
    );
  }

  DescriptionTexrField(String text, Color color) {
    return InputDecoration(
      hintText: text,
      hintStyle: Text_Style.textStyleBold(color, 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6)),
      ),
    );
  }

  DataTextFieldStyle(String text, Icon icon, Color color) {
    return InputDecoration(
      hintText: text,
      prefixIcon: icon,
      prefixIconColor: color,
      labelStyle: TextStyle(
        fontFamily: Fonts.PrimaryFont,
        fontSize: 16,
        color: Colors.black54,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
  }
}
