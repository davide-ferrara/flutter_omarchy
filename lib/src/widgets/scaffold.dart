import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/theme/theme.dart';
import 'package:flutter_omarchy/src/widgets/resize_divider.dart';

typedef OmarchyScaffoldLeadingMenuState = ({bool isHidden, double width});

class OmarchyScaffold extends StatefulWidget {
  const OmarchyScaffold({
    super.key,
    required this.child,
    this.leadingMenu,
    this.navigationBar,
    this.status,
    this.minLeadingMenuWidth = 50.0,
    this.maxLeadingMenuWidth = 500.0,
    this.hideLeadingMenuUnderWidth,
  });

  static OmarchyScaffoldLeadingMenuState? leadingMenuMaybeOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<_LeadingMenuStateProvider>()
        ?.state;
  }

  static OmarchyScaffoldLeadingMenuState leadingMenuOf(BuildContext context) {
    return leadingMenuMaybeOf(context)!;
  }

  /// If the leading menu is hidden, this will show it modally.
  static Future<void> showLeadingMenu(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_LeadingMenuStateProvider>();
    if (inherited != null) {
      inherited.show();
    }
    return Future.value();
  }

  static Future<void> hideLeadingMenu(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_LeadingMenuStateProvider>();
    if (inherited != null) {
      inherited.hide();
    }
    return Future.value();
  }

  final Widget child;
  final Widget? leadingMenu;
  final Widget? navigationBar;
  final Widget? status;
  final double minLeadingMenuWidth;
  final double maxLeadingMenuWidth;

  /// If null, default to a third of the scaffold's width.
  ///
  /// If 0, then always show the leading menu.
  final double? hideLeadingMenuUnderWidth;

  @override
  State<OmarchyScaffold> createState() => _OmarchyScaffoldState();
}

class _OmarchyScaffoldState extends State<OmarchyScaffold> {
  var leadingMenuWidth = 300.0;
  final contentKey = GlobalKey();
  final menuKey = GlobalKey();
  final overlayController = OverlayPortalController();

  void showLeadingMenu() {
    if (!overlayController.isShowing) overlayController.show();
  }

  void hideLeadingMenu() {
    if (overlayController.isShowing) overlayController.hide();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return LayoutBuilder(
      builder: (context, layout) {
        var child = widget.child;
        final hideLeadingMenuUnderWidth =
            widget.hideLeadingMenuUnderWidth ?? layout.maxWidth / 3;
        final isLeadingMenuHidden =
            leadingMenuWidth >= hideLeadingMenuUnderWidth;

        if (widget.navigationBar case final bar?) {
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              bar,
              Expanded(key: Key('main'), child: child),
            ],
          );
        }
        if (widget.leadingMenu case final menu?) {
          if (!isLeadingMenuHidden) {
            child = Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(key: menuKey, width: leadingMenuWidth, child: menu),
                OmarchyResizeDivider(
                  key: Key('divider'),
                  min: widget.minLeadingMenuWidth,
                  max: widget.maxLeadingMenuWidth,
                  size: leadingMenuWidth,
                  onSizeChanged: (v) => setState(() {
                    leadingMenuWidth = v;
                  }),
                ),
                Expanded(key: contentKey, child: child),
              ],
            );
          } else {
            child = OverlayPortal(
              controller: overlayController,
              overlayChildBuilder: (context) {
                return Positioned.fill(
                  child: _LeadingMenuStateProvider(
                    state: (
                      isHidden: isLeadingMenuHidden,
                      width: leadingMenuWidth,
                    ),
                    show: showLeadingMenu,
                    hide: hideLeadingMenu,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: const Color(0x33000000),
                            child: GestureDetector(
                              onTap: () {
                                if (overlayController.isShowing) {
                                  overlayController.hide();
                                }
                              },
                            ),
                          ),
                        ),
                        Positioned.fill(
                          right: 64,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colors.background,
                              border: Border(
                                right: BorderSide(
                                  color: theme.colors.border,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: menu,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: KeyedSubtree(key: contentKey, child: child),
            );
          }
        }

        if (widget.status case final status?) {
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(key: Key('main'), child: child),
              status,
            ],
          );
        }
        return _LeadingMenuStateProvider(
          state: (isHidden: isLeadingMenuHidden, width: leadingMenuWidth),
          show: showLeadingMenu,
          hide: hideLeadingMenu,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color: theme.colors.background,
            child: child,
          ),
        );
      },
    );
  }
}

class _LeadingMenuStateProvider extends InheritedWidget {
  const _LeadingMenuStateProvider({
    required this.state,
    required super.child,
    required this.hide,
    required this.show,
  });
  final OmarchyScaffoldLeadingMenuState state;
  final VoidCallback show;
  final VoidCallback hide;

  @override
  bool updateShouldNotify(covariant _LeadingMenuStateProvider oldWidget) {
    return state != oldWidget.state;
  }
}
