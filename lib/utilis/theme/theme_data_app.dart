import 'package:flutter/material.dart';
import 'package:todo_task_umg/utilis/theme/colors_app.dart';

class ThemeDataApp {
  static ThemeData themeData() {
    return ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: ColorsApp.background),
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: ColorsApp.textColorLabel),
        fillColor: ColorsApp.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: ColorsApp.textFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: ColorsApp.textFieldFocusedBorder),
        ),
        hintStyle: TextStyle(color: ColorsApp.textFieldHintColor),
        errorStyle: TextStyle(color: ColorsApp.textColorError),
        filled: true,
        contentPadding: EdgeInsets.all(10),
      ),
      //Button
      buttonTheme: ButtonThemeData(
        buttonColor: ColorsApp.buttonBackground,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        hoverColor: ColorsApp.hoverButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
