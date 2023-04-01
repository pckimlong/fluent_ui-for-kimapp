import 'package:fluent_ui/fluent_ui.dart';

enum PasswordRevealMode {
  /// The password reveal button is visible. The password is not obscured while
  /// the button is pressed.
  ///
  /// If the focus is lost, the button will be hidden on next time the focus
  /// is got until the password box is cleared. (This is a security concern).
  ///
  /// If you want to keep the reveal button visible, see [peekAlways].
  peek,

  /// The password reveal button is visible. The button is not obscured while
  /// the button is pressed.
  ///
  /// The reveal button will always be visible if the password box has the focus
  /// and it's not empty. Unlike the [peek] mode, if the focus is regained,
  /// the reveal button will be visible.
  peekAlways,

  /// The password reveal button is not visible. The password is
  /// always obscured.
  hidden,

  /// The password reveal button is not visible. The password is not obscured.
  visible,
}

/// A fluent design input form for password.
///
/// A password box is a text input box that conceals the characters typed into
/// it for the purpose of privacy. A password box looks like a text box, except
/// that it renders placeholder characters in place of the text that has been
/// entered. You can configure the placeholder character.
///
/// ![PasswordBox](https://learn.microsoft.com/en-us/windows/apps/design/controls/images/passwordbox-focus-typing.png)
///
/// See also:
///
///  * <https://learn.microsoft.com/en-us/windows/apps/design/controls/password-box>
///  * [PasswordRevealMode], the different modes that the password box can have
///  * [TextBox], the underlaying widget that renders the text box
class PasswordBox extends StatefulWidget {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Disables the text field when false.
  ///
  /// Text fields in disabled states have a light grey background and don't
  /// respond to touch events.
  final bool enabled;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// The reveal mode determine how the password is visible or obscured.
  final PasswordRevealMode revealMode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// A widget displayed at the start of the text box
  ///
  /// Usually an [IconButton] or [Icon]
  final Widget? leadingIcon;

  /// The text shown when the text box is empty
  ///
  /// See also:
  ///
  ///  * [TextBox.placeholder]
  final String? placeholder;

  /// The style of [placeholder]
  ///
  /// See also:
  ///
  ///  * [TextBox.placeholderStyle]
  final TextStyle? placeholderStyle;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius cursorRadius;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  final Color? cursorColor;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// The highlight color of the text box.
  ///
  /// If [foregroundDecoration] is provided, this must not be provided.
  ///
  /// See also:
  ///  * [unfocusedColor], displayed when the field is not focused
  final Color? highlightColor;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  final String obscuringCharacter;

  /// Creates a password box
  const PasswordBox({
    super.key,
    this.controller,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.placeholder,
    this.revealMode = PasswordRevealMode.peek,
    this.autofocus = false,
    this.leadingIcon,
    this.placeholderStyle,
    this.cursorWidth = 1.5,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorHeight,
    this.cursorColor,
    this.showCursor,
    this.highlightColor,
    this.readOnly = false,
    this.obscuringCharacter = '•',
  });

  @override
  State<PasswordBox> createState() => _PasswordBoxState();
}

class _PasswordBoxState extends State<PasswordBox> {
  bool peek = false;
  bool focusCanPeek = true;
  bool textCanPeek = false;

  TextEditingController? _internalController;
  TextEditingController? get controller =>
      widget.controller ?? _internalController;

  FocusNode? _internalNode;
  FocusNode? get focusNode => widget.focusNode ?? _internalNode;

  bool get _isVisible =>
      widget.revealMode == PasswordRevealMode.visible ||
      ((widget.revealMode == PasswordRevealMode.peek ||
              widget.revealMode == PasswordRevealMode.peekAlways) &&
          peek);

  bool get _canPeek =>
      (widget.revealMode == PasswordRevealMode.peekAlways && textCanPeek) ||
      (widget.revealMode == PasswordRevealMode.peek &&
          focusCanPeek &&
          textCanPeek);

  @override
  void initState() {
    if (widget.focusNode == null) {
      _internalNode = FocusNode(debugLabel: '${widget.runtimeType}');
    }
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    controller!.addListener(_handleTextChange);
    focusNode!.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    controller!.removeListener(_handleTextChange);
    if (widget.controller == null) {
      controller!.dispose();
    }

    focusNode!.removeListener(_handleFocusChange);
    if (widget.focusNode != null) {
      focusNode!.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PasswordBox oldWidget) {
    if (oldWidget.controller == null && widget.controller != null) {
      _internalController?.dispose();
      _internalController = null;
      controller!.addListener(_handleTextChange);
    } else if (oldWidget.controller != null && widget.controller == null) {
      oldWidget.controller!.removeListener(_handleTextChange);
      _internalController = TextEditingController();
      controller!.addListener(_handleTextChange);
    }

    if (oldWidget.focusNode == null && widget.focusNode != null) {
      _internalNode?.dispose();
      _internalNode = null;
      focusNode!.addListener(_handleFocusChange);
    } else if (oldWidget.focusNode != null && widget.focusNode == null) {
      oldWidget.focusNode!.removeListener(_handleFocusChange);
      _internalNode = FocusNode(debugLabel: '${widget.runtimeType}');
      focusNode!.addListener(_handleFocusChange);
    }

    if (oldWidget.revealMode == PasswordRevealMode.peekAlways &&
        widget.revealMode == PasswordRevealMode.peek) {
      // if the mode change, we consider that the first focus is gone.
      focusCanPeek = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _handleTextChange() {
    if (controller!.text.isEmpty) {
      // If the text box is empty, then we ignore if the focus has been
      // lost or not previously.
      focusCanPeek = true;
    }

    if (controller!.text.isNotEmpty && !textCanPeek) {
      // If the text box is not empty, the reveal button must be visible
      // (it will be only if focusCanPeek is true !)
      setState(() {
        textCanPeek = true;
      });
    } else if (controller!.text.isEmpty && textCanPeek) {
      // If the text box is empty, the reveal button must be hidden.
      setState(() {
        textCanPeek = false;
      });
    }
  }

  void _handleFocusChange() {
    if (!focusNode!.hasFocus && controller!.text.isNotEmpty) {
      // If the focus is lost and the text box is not empty, then the reveal
      // button must not be hidden.
      setState(() {
        focusCanPeek = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextBox(
      focusNode: focusNode,
      controller: controller,
      enabled: widget.enabled,
      placeholder: widget.placeholder,
      placeholderStyle: widget.placeholderStyle,
      obscureText: !_isVisible,
      suffix: _canPeek
          ? SmallIconButton(
              child: IconButton(
                icon: const Icon(FluentIcons.red_eye),
                // todo: half eye icon, like WinUI3 ?
                onPressed: null,
                onTapDown: widget.enabled
                    ? () {
                        setState(() {
                          peek = true;
                        });
                      }
                    : null,
                onTapUp: widget.enabled
                    ? () {
                        setState(() {
                          peek = false;
                        });
                      }
                    : null,
              ),
            )
          : null,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      prefix: widget.leadingIcon,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorHeight: widget.cursorHeight,
      cursorColor: widget.cursorColor,
      highlightColor: widget.highlightColor,
      readOnly: widget.readOnly,
      obscuringCharacter: widget.obscuringCharacter,
    );
  }
}
