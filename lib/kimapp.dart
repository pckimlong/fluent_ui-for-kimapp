// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'fluent_ui.dart';

abstract class DefaultKimappFluentStyle {
  static const Color scaffoldBackgroundColor = Color.fromARGB(255, 250, 250, 250);
  static final AccentColor defaultAccentColor = Colors.blue;
  static const double defaultBorderRadius = 4;
  static const double defaultComponentHeight = 33.5;
  static final Color defaultBorderColor = Colors.black.withOpacity(0.3);

  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1000;
}

class KimappStyle extends ThemeExtension<KimappStyle> {
  final double borderRadius;
  final double baseComponentHeight;
  final Color borderColor;
  final double borderWidth;

  KimappStyle({
    required this.borderRadius,
    required this.baseComponentHeight,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  ThemeExtension<KimappStyle> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<KimappStyle> lerp(covariant ThemeExtension<KimappStyle>? other, double t) {
    return this;
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
        borderColor: borderColor ?? DefaultKimappFluentStyle.defaultBorderColor,
        borderWidth: borderWidth,
      ),
    ],
  );
}

//
extension BuildContextX on BuildContext {
  FluentThemeData get theme => FluentTheme.of(this);
  Typography get textTheme => theme.typography;
  Color get primaryColor => theme.accentColor;

  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  EdgeInsets get keyboardPadding => EdgeInsets.only(bottom: MediaQuery.of(this).viewInsets.bottom);
}

extension FluentThemeDataX on FluentThemeData {
  Color get disabledColor => resources.textFillColorDisabled;
}

// custom widget

class ResponsiveBox extends StatelessWidget {
  const ResponsiveBox({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, BoxConstraints constraints, bool isMobile) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final isMobile = constraint.maxWidth <= DefaultKimappFluentStyle.mobileBreakpoint;
        return builder(context, constraint, isMobile);
      },
    );
  }
}

class MyInfoLabelTheme extends InheritedTheme {
  const MyInfoLabelTheme({
    Key? key,
    this.labelWidth,
    this.labelAlign = TextAlign.start,
    this.labelStyle,
    required super.child,
  }) : super(key: key);

  final double? labelWidth;
  final TextStyle? labelStyle;
  final TextAlign labelAlign;

  static MyInfoLabelTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInfoLabelTheme>();
  }

  @override
  bool updateShouldNotify(MyInfoLabelTheme oldWidget) {
    return oldWidget.labelWidth != labelWidth;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MyInfoLabelTheme(child: child);
  }
}

class MyInfoLabel extends StatelessWidget {
  MyInfoLabel({
    Key? key,
    this.child,
    required String label,
    TextStyle? labelStyle,
    this.isHeader,
    this.isHeaderOnMobile = true,
    this.isRequired = false,
  })  : label = TextSpan(
          text: label,
          style: labelStyle,
          children: [if (isRequired) TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
        ),
        super(key: key);

  final InlineSpan label;

  final Widget? child;

  final bool? isHeader;

  final bool isHeaderOnMobile;

  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = MyInfoLabelTheme.maybeOf(context);

    Widget labelWidget = Text.rich(
      label,
      textAlign: theme?.labelAlign ?? TextAlign.start,
      style: theme?.labelStyle ?? context.textTheme.caption?.copyWith(fontWeight: FontWeight.bold),
    );

    final labelWidth = theme?.labelWidth;
    if (labelWidth != null) {
      labelWidget = SizedBox(
        width: labelWidth,
        child: labelWidget,
      );
    }

    return ResponsiveBox(
      builder: (BuildContext context, BoxConstraints constraints, bool isMobile) {
        var isHeaderLayout = false;
        if (isHeader != null) {
          isHeaderLayout = isHeader!;
        } else {
          if (isHeaderOnMobile) {
            isHeaderLayout = isMobile;
          }
        }

        return Flex(
          direction: isHeaderLayout ? Axis.vertical : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isHeaderLayout ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            if (isHeaderLayout)
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 4.0),
                child: labelWidget,
              )
            else
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: labelWidget,
              ),
            if (child != null) Flexible(child: child!),
          ],
        );
      },
    );
  }
}

class ProgressFilledButton extends StatelessWidget {
  const ProgressFilledButton({
    Key? key,
    this.onPressed,
    this.isProgressing = false,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final bool isProgressing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FluentTheme(
            data: context.theme.copyWith(
              iconTheme: context.theme.iconTheme
                  .copyWith(color: isProgressing ? Colors.transparent : Colors.white, size: 14.0),
            ),
            child: DefaultTextStyle(
              style: context.textTheme.body!.copyWith(
                color: isProgressing ? Colors.transparent : Colors.white,
                height: 1.12,
              ),
              child: child,
            ),
          ),
          if (isProgressing)
            const Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: ProgressRing(strokeWidth: 3.5),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ProgressButton extends StatelessWidget {
  const ProgressButton({
    Key? key,
    this.onPressed,
    this.isProgressing = false,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final bool isProgressing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FluentTheme(
            data: context.theme.copyWith(
              iconTheme: context.theme.iconTheme
                  .copyWith(color: isProgressing ? Colors.transparent : null, size: 14),
            ),
            child: DefaultTextStyle(
              style: context.textTheme.body!.copyWith(
                color: isProgressing ? Colors.transparent : null,
                height: 1.12,
              ),
              child: child,
            ),
          ),
          if (isProgressing)
            const Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: ProgressRing(strokeWidth: 3.5),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ProgressDivider extends StatelessWidget {
  const ProgressDivider({
    super.key,
    this.width,
    this.isProgressing = false,
  });

  final bool isProgressing;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: isProgressing
          ? SizedBox(
              width: double.infinity,
              child: ProgressBar(strokeWidth: context.theme.dividerTheme.thickness ?? 1),
            )
          : const Divider(),
    );
  }
}
