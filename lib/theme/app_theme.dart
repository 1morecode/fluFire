import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/res/my_colors.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimaryColor = MyColors.yellow;
  static const Color _lightPrimaryVariantColor = MyColors.yellow;
  static const Color _lightOnPrimaryColor = MyColors.white;
  static const Color _lightSecondaryColor = MyColors.yellow;
  static const Color _lightGreyColor = MyColors.lightGrey;
  static const Color _lightBrightColor = MyColors.darkGrey;
  static const Color _lightTextColor = MyColors.black;
  static const Color _lightTextVariantColor = MyColors.lightBlack;

  static final TextStyle _lightScreenHeadingTextStyle =
      TextStyle(fontSize: 32.0, color: _lightPrimaryVariantColor);
  static final TextStyle _lightSubHeadingTextStyle =
      TextStyle(fontSize: 18.0, color: _lightBrightColor);
  static final TextStyle _lightAppBarHeadingTextStyle = TextStyle(
      fontSize: 20.0, color: _lightOnPrimaryColor, fontWeight: FontWeight.w700);
  static final TextStyle _lightScreenTaskNameTextStyle = TextStyle(
      fontSize: 20.0,
      color: _lightTextVariantColor,
      fontWeight: FontWeight.w500);
  static final TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(fontSize: 16.0, color: _lightTextColor);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightGreyColor,
    inputDecorationTheme: InputDecorationTheme(fillColor: _lightPrimaryColor),
    appBarTheme: AppBarTheme(
      color: _lightOnPrimaryColor,
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: _lightPrimaryColor,
      ),
      titleTextStyle: TextStyle(color: _lightPrimaryColor)
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
        barBackgroundColor: _lightOnPrimaryColor,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(primaryColor: _lightPrimaryColor),
        primaryColor: _lightPrimaryColor),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryVariant: _lightPrimaryVariantColor,
      secondary: _lightSecondaryColor,
      onPrimary: _lightOnPrimaryColor,
      onSecondary: _lightTextColor,
      background: _lightPrimaryColor,
      surface: _lightGreyColor,
      onSurface: _lightGreyColor,
      brightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: _lightPrimaryColor, size: 24),
    textTheme: _lightTextTheme,
    disabledColor: _lightBrightColor,
    dialogBackgroundColor: _lightPrimaryVariantColor,
    accentColor: _lightPrimaryColor,
    cardTheme: CardTheme(elevation: 2, color: _lightOnPrimaryColor),
    backgroundColor: _lightOnPrimaryColor,
    splashFactory: InkRipple.splashFactory,
    dividerColor: Colors.grey.withOpacity(0.3),
  );

  static final TextTheme _lightTextTheme = TextTheme(
      headline5: _lightScreenHeadingTextStyle,
      bodyText2: _lightScreenTaskNameTextStyle,
      bodyText1: _lightScreenTaskDurationTextStyle,
      headline1: _lightAppBarHeadingTextStyle,
      subtitle1: _lightScreenHeadingTextStyle,
      headline2: _lightSubHeadingTextStyle,
      caption: _lightScreenTaskDurationTextStyle);

  // Dark Theme
  static const Color _darkPrimaryColor = MyColors.yellow;
  static const Color _darkPrimaryVariantColor = MyColors.yellow;
  static const Color _darkOnPrimaryColor = MyColors.black;
  static const Color _darkSecondaryColor = MyColors.yellow;
  static const Color _darkGreyColor = MyColors.lightBlack;
  static const Color _darkBrightColor = MyColors.lightBlack;
  static const Color _darkTextColor = MyColors.white;
  static const Color _darkTextVariantColor = MyColors.lightGrey;

  static final TextStyle _darkScreenHeadingTextStyle =
      TextStyle(fontSize: 32.0, color: _darkPrimaryVariantColor);
  static final TextStyle _darkSubHeadingTextStyle =
      TextStyle(fontSize: 18.0, color: _darkTextVariantColor);
  static final TextStyle _darkAppBarHeadingTextStyle = TextStyle(
      fontSize: 20.0, color: _darkTextColor, fontWeight: FontWeight.w700);
  static final TextStyle _darkScreenTaskNameTextStyle = TextStyle(
      fontSize: 20.0,
      color: _darkTextVariantColor,
      fontWeight: FontWeight.w500);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      TextStyle(fontSize: 16.0, color: _darkTextColor);

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkGreyColor,
    inputDecorationTheme: InputDecorationTheme(fillColor: _darkPrimaryColor),
    appBarTheme: AppBarTheme(
      color: _darkOnPrimaryColor,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: _darkPrimaryColor,
      ),
        titleTextStyle: TextStyle(color: _darkPrimaryColor)
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
        barBackgroundColor: _darkOnPrimaryColor,
        brightness: Brightness.dark,
        primaryContrastingColor: _darkOnPrimaryColor,
        textTheme: CupertinoTextThemeData(primaryColor: _darkPrimaryColor),
        primaryColor: _darkPrimaryColor),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryColor,
      primaryVariant: _darkPrimaryVariantColor,
      secondary: _darkSecondaryColor,
      onPrimary: _darkOnPrimaryColor,
      onSecondary: _darkTextColor,
      background: _darkPrimaryColor,
      surface: _darkGreyColor,
      onSurface: _darkGreyColor,
      brightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: _darkPrimaryColor, size: 24),
    textTheme: _darkTextTheme,
    disabledColor: _darkBrightColor,
    dialogBackgroundColor: _darkPrimaryVariantColor,
    accentColor: _darkPrimaryColor,
    cardTheme: CardTheme(elevation: 2, color: _darkOnPrimaryColor),
    backgroundColor: _darkOnPrimaryColor,
    splashFactory: InkRipple.splashFactory,
    dividerColor: Colors.grey.withOpacity(0.3),
  );

  static final TextTheme _darkTextTheme = TextTheme(
      headline5: _darkScreenHeadingTextStyle,
      bodyText2: _darkScreenTaskNameTextStyle,
      bodyText1: _darkScreenTaskDurationTextStyle,
      headline1: _darkAppBarHeadingTextStyle,
      headline2: _darkSubHeadingTextStyle,
      subtitle1: _darkScreenHeadingTextStyle,
      headline3: _darkAppBarHeadingTextStyle,
      caption: _darkScreenTaskDurationTextStyle);
}
