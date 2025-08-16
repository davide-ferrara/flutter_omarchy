import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';
import 'package:flutter_omarchy/src/widgets/utils/title_bar.dart';

class OmarchyNavigationBar extends StatelessWidget {
  const OmarchyNavigationBar({super.key, required this.title, this.height});

  final Widget title;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);

    return Container(
      height: omarchy.theme.text.normal.fontSize! * 4,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: omarchy.theme.colors.normal.black,
          ),
        ),
      ),
      child: TitleBar(
        title: DefaultTextStyle(
          style: omarchy.theme.text.bold.copyWith(
            color: omarchy.theme.colors.foreground,
          ),
          child: title,
        ),
      ),
    );
  }
}
