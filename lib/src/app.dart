import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';

class OmarchyApp extends StatelessWidget {
  const OmarchyApp({
    super.key,
    required this.home,
    this.debugShowCheckedModeBanner = kDebugMode,
  });

  final bool debugShowCheckedModeBanner;
  final Widget home;

  static PageRoute<T> defaultPageRouteBuilder<T>(
    RouteSettings settings,
    WidgetBuilder builder,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) {
        return builder(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Omarchy(
      child: Builder(
        builder: (context) {
          final omarchy = Omarchy.of(context);
          return WidgetsApp(
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            color: omarchy.theme.colors.border,
            pageRouteBuilder: defaultPageRouteBuilder,
            textStyle: omarchy.theme.text.normal.copyWith(
              color: omarchy.theme.colors.foreground,
            ),
            home: home,
          );
        },
      ),
    );
  }
}
