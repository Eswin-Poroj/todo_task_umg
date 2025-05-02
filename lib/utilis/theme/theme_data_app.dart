import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_task_umg/utilis/theme/colors_app.dart';

class ThemeDataApp {
  static ThemeData themeData() {
    return ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: ColorsApp.backgroundAppBar),
      scaffoldBackgroundColor: ColorsApp.background,
      textTheme: GoogleFonts.robotoTextTheme(),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          iconAlignment: IconAlignment.start,
          iconColor: ColorsApp.textButtonColor,
          iconSize: 18.0,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 55),
          backgroundColor: ColorsApp.buttonBackground,
          foregroundColor: ColorsApp.textButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: ColorsApp.textFieldBorder, width: 1.0),
          ),
          elevation: 10.0,
        ),
      ),
    );
  }
}
