import 'package:example/main.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

/// All the sample apps in a simulated Omarchy desktop.
///
/// This is for demonstration purpose on web.
class OmarchyPreview extends StatefulWidget {
  const OmarchyPreview({super.key, required this.initialApp});
  final App initialApp;

  @override
  State<OmarchyPreview> createState() => _OmarchyPreviewState();
}

class _OmarchyPreviewState extends State<OmarchyPreview> {
  late var app = widget.initialApp;
  @override
  Widget build(BuildContext context) {
    final colors = OmarchyColorThemes.tokyoNight;
    const text = OmarchyTextStyleData.fallback();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Container(
            height: 24,
            decoration: BoxDecoration(color: colors.background),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              scrollDirection: Axis.horizontal,
              children: [
                PointerArea(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Icon(
                        OmarchyIcons.devGithub,
                        color: colors.normal.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                for (final app in App.values)
                  PointerArea(
                    onTap: () {
                      setState(() {
                        this.app = app;
                      });
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          app.name.toUpperCase(),
                          style: text.normal.copyWith(
                            fontSize: 11,
                            color: app == this.app
                                ? colors.selectedText
                                : colors.foreground,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/wallpaper.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(14.0),
              child: OmarchyWindow(
                child: IndexedStack(
                  index: app.index,
                  children: [for (final app in App.values) app.build()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OmarchyWindow extends StatelessWidget {
  const OmarchyWindow({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = OmarchyColorThemes.tokyoNight;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0x88000000), width: 0.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colors.border, width: 2),
        ),
        child: Opacity(opacity: 0.98, child: child),
      ),
    );
  }
}
