// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'fluent_ui.dart';

abstract class DefaultKimappFluentStyle {
  static const Color scaffoldBackgroundColor = Color.fromARGB(255, 250, 250, 250);
  static final AccentColor defaultAccentColor = Colors.blue;
  static const double defaultBorderRadius = 4;
  static const double defaultComponentHeight = 33.5;
  static final Color defaultBorderColor = Colors.black.withOpacity(0.3);
}

class KimappStyle extends ThemeExtension<KimappStyle> {
  final double borderRadius;
  final double baseComponentHeight;
  KimappStyle({
    required this.borderRadius,
    required this.baseComponentHeight,
  });

  @override
  ThemeExtension<KimappStyle> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<KimappStyle> lerp(covariant ThemeExtension<KimappStyle>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}

FluentThemeData kimappFluentTheme({
  Color? scaffoldBackgroundColor = DefaultKimappFluentStyle.scaffoldBackgroundColor,
  AccentColor? accentColor,
  Color? customAccentColor,
  String? fontFamily,
  double borderRadius = DefaultKimappFluentStyle.defaultBorderRadius,
  double borderWidth = 0.5,
  Color? borderColor,
  double componentHeight = DefaultKimappFluentStyle.defaultComponentHeight,
  ButtonStyle? filledButtonStyle,
  ButtonStyle? defaultButtonStyle,
  ButtonStyle? outlineButtonStyle,
  ButtonStyle? iconButtonStyle,
  double? dividerThickness,
  Color? dividerColor,
}) {
  final effectiveAccentColor = customAccentColor?.toAccentColor() ??
      accentColor ??
      DefaultKimappFluentStyle.defaultAccentColor;

  final buttonStyle = ButtonStyle(
    shape: ButtonState.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor ?? DefaultKimappFluentStyle.defaultBorderColor,
          width: borderWidth,
        ),
      ),
    ),
  );

  return FluentThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    fontFamily: fontFamily,
    accentColor: effectiveAccentColor,
    buttonTheme: ButtonThemeData(
      filledButtonStyle: filledButtonStyle ?? buttonStyle,
      outlinedButtonStyle: outlineButtonStyle ?? buttonStyle,
      defaultButtonStyle: defaultButtonStyle ?? buttonStyle,
      iconButtonStyle: iconButtonStyle,
    ),
    dividerTheme: DividerThemeData(
      horizontalMargin: const EdgeInsets.all(0),
      thickness: dividerThickness ?? borderWidth,
      decoration: BoxDecoration(color: dividerColor ?? Colors.grey[50]),
    ),
    extensions: [
      KimappStyle(
        borderRadius: borderRadius,
        baseComponentHeight: componentHeight,
      ),
    ],
  );
}
