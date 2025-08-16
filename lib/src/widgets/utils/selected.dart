import 'package:flutter/widgets.dart';

class IsSelected extends InheritedWidget {
  const IsSelected({super.key, required super.child, required this.isSelected});

  final bool isSelected;

  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<IsSelected>()
            ?.isSelected ??
        false;
  }

  @override
  bool updateShouldNotify(covariant IsSelected oldWidget) {
    return isSelected != oldWidget.isSelected;
  }
}
