import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

class OmarchyButton extends StatelessWidget {
  const OmarchyButton({
    super.key,
    required this.onPressed,
    required this.child,
  });
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context).theme;

    return PointerArea(
      onTap: onPressed,
      child: child,
      builder: (context, state, child) {
        final border = switch (state) {
          PointerState(hasFocus: true) => omarchy.colors.bright.cyan,
          PointerState(isPressed: true) => omarchy.colors.bright.white,
          _ => omarchy.colors.normal.white,
        };
        final foreground = switch (state) {
          PointerState(hasFocus: true) => omarchy.colors.bright.cyan,
          _ => omarchy.colors.bright.white,
        };
        final background = switch (state) {
          PointerState(isPressed: true) => omarchy.colors.normal.black,
          _ => omarchy.colors.normal.black.withValues(alpha: 0),
        };
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: background,
            border: BoxBorder.all(width: 2, color: border),
          ),
          padding: const EdgeInsets.all(16),
          child: IconTheme(
            data: IconThemeData(color: foreground),
            child: child!,
          ),
        );
      },
    );
  }
}

final class PointerState {
  const PointerState({
    required this.hasFocus,
    required this.isPressed,
    required this.isHovering,
  });

  final bool hasFocus;
  final bool isPressed;
  final bool isHovering;

  static PointerState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PointerStateProvider>()
        ?.state;
  }

  static PointerState of(BuildContext context) {
    final PointerState? state = maybeOf(context);
    assert(state != null, 'No PointerStateProvider found in context');
    return state!;
  }

  PointerState copyWith({bool? hasFocus, bool? isPressed, bool? isHovering}) {
    return PointerState(
      hasFocus: hasFocus ?? this.hasFocus,
      isPressed: isPressed ?? this.isPressed,
      isHovering: isHovering ?? this.isHovering,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final PointerState otherState = other as PointerState;
    return hasFocus == otherState.hasFocus &&
        isPressed == otherState.isPressed &&
        isHovering == otherState.isHovering;
  }

  @override
  int get hashCode {
    return Object.hash(hasFocus, isPressed, isHovering);
  }

  @override
  String toString() {
    return 'PointerState(hasFocus: $hasFocus, isPressed: $isPressed, isHovering: $isHovering)';
  }
}

class PointerStateProvider extends InheritedWidget {
  const PointerStateProvider({
    super.key,
    required this.state,
    required super.child,
  });

  final PointerState state;

  @override
  bool updateShouldNotify(PointerStateProvider oldWidget) {
    return oldWidget.state != state;
  }
}

/// Based on InkResponse, but without the ink splash effect.
class PointerArea extends StatefulWidget {
  const PointerArea({
    super.key,
    this.hoverCursor = SystemMouseCursors.click,
    this.child,
    this.focusNode,
    this.autofocus = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.excludeFromSemantics = false,
    this.enableFeedback = true,
    this.canRequestFocus = true,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    this.onHoverStart,
    this.onHoverEnd,
    this.builder,
  }) : assert(
         child != null || builder != null,
         'Either child or builder must be provided.',
       );

  final Widget? child;
  final Widget Function(
    BuildContext context,
    PointerState state,
    Widget? child,
  )?
  builder;
  final FocusNode? focusNode;
  final MouseCursor hoverCursor;
  final bool autofocus;
  final VoidCallback? onHoverStart;
  final VoidCallback? onHoverEnd;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final bool excludeFromSemantics;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTapCancel;
  final bool enableFeedback;
  final bool canRequestFocus;

  @override
  State<PointerArea> createState() => _PointerAreaState();
}

class _PointerAreaState extends State<PointerArea> {
  var _hasFocus = false;
  var _hovering = false;
  var _pressed = false;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: activateOnIntent),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: activateOnIntent,
    ),
  };

  void activateOnIntent(Intent? intent) {
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      widget.onTap?.call();
    }
  }

  bool get _canRequestFocus =>
      switch (MediaQuery.maybeNavigationModeOf(context)) {
        NavigationMode.traditional || null => enabled && widget.canRequestFocus,
        NavigationMode.directional => true,
      };

  void handleFocusUpdate(bool hasFocus) {
    setState(() {
      _hasFocus = hasFocus;
    });
  }

  bool isWidgetEnabled(PointerArea widget) {
    return _primaryButtonEnabled(widget) || _secondaryButtonEnabled(widget);
  }

  bool _primaryButtonEnabled(PointerArea widget) {
    return widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onLongPress != null ||
        widget.onTapUp != null ||
        widget.onTapDown != null;
  }

  bool _secondaryButtonEnabled(PointerArea widget) {
    return widget.onSecondaryTap != null ||
        widget.onSecondaryTapUp != null ||
        widget.onSecondaryTapDown != null;
  }

  bool get enabled => isWidgetEnabled(widget);
  bool get _primaryEnabled => _primaryButtonEnabled(widget);
  bool get _secondaryEnabled => _secondaryButtonEnabled(widget);

  void handleAnyTapDown(TapDownDetails details) {
    if (!_pressed) {
      setState(() {
        _pressed = true;
      });
    }
  }

  void handleAnyTapUpOrCancel() {
    if (_pressed) {
      setState(() {
        _pressed = false;
      });
    }
  }

  void handleTap() {
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      widget.onTap?.call();
    }
  }

  void handleTapDown(TapDownDetails details) {
    handleAnyTapDown(details);
    widget.onTapDown?.call(details);
  }

  void handleTapUp(TapUpDetails details) {
    handleAnyTapUpOrCancel();
    widget.onTapUp?.call(details);
  }

  void handleSecondaryTapDown(TapDownDetails details) {
    handleAnyTapDown(details);
    widget.onSecondaryTapDown?.call(details);
  }

  void handleTapCancel() {
    handleAnyTapUpOrCancel();
    widget.onTapCancel?.call();
  }

  void handleDoubleTap() {
    widget.onDoubleTap?.call();
  }

  void handleLongPress() {
    if (widget.onLongPress != null) {
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      widget.onLongPress!();
    }
  }

  void handleSecondaryTap() {
    widget.onSecondaryTap?.call();
  }

  void handleSecondaryTapUp(TapUpDetails details) {
    widget.onSecondaryTapUp?.call(details);
  }

  void handleSecondaryTapCancel() {
    widget.onSecondaryTapCancel?.call();
  }

  void handleMouseEnter(PointerEnterEvent event) {
    if (!_hovering) {
      widget.onHoverStart?.call();
      setState(() {
        _hovering = true;
      });
    }
  }

  void handleMouseExit(PointerExitEvent event) {
    if (_hovering) {
      widget.onHoverEnd?.call();
      setState(() {
        _hovering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMouseCursor = _hovering
        ? widget.hoverCursor
        : SystemMouseCursors.basic;

    final state = PointerState(
      hasFocus: _hasFocus,
      isPressed: _pressed,
      isHovering: _hovering,
    );
    Widget? child = widget.child != null
        ? PointerStateProvider(state: state, child: widget.child!)
        : null;

    if (widget.builder != null) {
      child = widget.builder!(context, state, child);
    }
    return Actions(
      actions: _actionMap,
      child: Focus(
        focusNode: widget.focusNode,
        canRequestFocus: _canRequestFocus,
        onFocusChange: handleFocusUpdate,
        autofocus: widget.autofocus,
        child: MouseRegion(
          cursor: effectiveMouseCursor,
          onEnter: handleMouseEnter,
          onExit: handleMouseExit,
          child: DefaultSelectionStyle.merge(
            mouseCursor: effectiveMouseCursor,
            child: Semantics(
              onTap: widget.excludeFromSemantics || widget.onTap == null
                  ? null
                  : handleTap,
              onLongPress:
                  widget.excludeFromSemantics || widget.onLongPress == null
                  ? null
                  : handleLongPress,
              child: GestureDetector(
                onTapDown: _primaryEnabled ? handleTapDown : null,
                onTapUp: _primaryEnabled ? handleTapUp : null,
                onTap: _primaryEnabled ? handleTap : null,
                onTapCancel: _primaryEnabled ? handleTapCancel : null,
                onDoubleTap: widget.onDoubleTap != null
                    ? handleDoubleTap
                    : null,
                onLongPress: widget.onLongPress != null
                    ? handleLongPress
                    : null,
                onSecondaryTapDown: _secondaryEnabled
                    ? handleSecondaryTapDown
                    : null,
                onSecondaryTapUp: _secondaryEnabled
                    ? handleSecondaryTapUp
                    : null,
                onSecondaryTap: _secondaryEnabled ? handleSecondaryTap : null,
                onSecondaryTapCancel: _secondaryEnabled
                    ? handleSecondaryTapCancel
                    : null,
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
