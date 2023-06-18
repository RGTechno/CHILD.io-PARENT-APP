import 'package:child_io_parent/color.dart';
import 'package:flutter/material.dart';

InputDecoration inpDec(
  String hintText,
  String labelText, {
  bool isSearch = false,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    labelStyle: TextStyle(
      color: textColor,
    ),
    prefixIcon: isSearch
        ? Icon(
            Icons.search,
            color: textColor,
          )
        : null,
    hintStyle: TextStyle(
      fontSize: 13,
      color: textColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: primaryColor),
    ),
  );
}
