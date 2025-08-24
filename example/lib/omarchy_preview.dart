import 'package:example/main.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String theme = 'tokyo-night';
  final allThemes = OmarchyColorThemes.all.entries.toList();

  void _nextTheme() {
    final currentIndex = allThemes.indexWhere(
      (element) => element.key == theme,
    );
    final nextIndex = (currentIndex + 1) % allThemes.length;
    setState(() {
      theme = allThemes[nextIndex].key;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = OmarchyColorThemes.all[theme]!;
    const text = OmarchyTextStyleData.fallback();
    final wallpaper = AssetImage('assets/$theme.jpg');
    final insets = MediaQuery.viewInsetsOf(context);
    return OmarchyThemeProvider(
      data: OmarchyThemeData(colors: colors, text: text),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            OmarchyDesktopBar(
              app: app,
              onAppChanged: (app) => setState(() => this.app = app),
              onNextTheme: _nextTheme,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: wallpaper, fit: BoxFit.cover),
                ),
                padding:
                    const EdgeInsets.all(14.0) +
                    EdgeInsets.only(bottom: insets.bottom),
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
      ),
    );
  }
}

class OmarchyDesktopBar extends StatelessWidget {
  const OmarchyDesktopBar({
    super.key,
    required this.app,
    required this.onAppChanged,
    required this.onNextTheme,
  });

  final App app;
  final ValueChanged<App> onAppChanged;
  final VoidCallback onNextTheme;

  @override
  Widget build(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return Container(
      height: 24,
      decoration: BoxDecoration(color: theme.colors.background),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        children: [
          PointerArea(
            onTap: () {
              launchUrl(
                Uri.parse('https://github.com/aloisdeniel/flutter_omarchy'),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Icon(
                  OmarchyIcons.devGithub,
                  color: theme.colors.normal.white,
                  size: 16,
                ),
              ),
            ),
          ),

          PointerArea(
            onTap: onNextTheme,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Icon(
                  OmarchyIcons.faePaletteColor,
                  color: theme.colors.normal.white,
                  size: 16,
                ),
              ),
            ),
          ),
          for (final app in App.values)
            PointerArea(
              onTap: () => onAppChanged(app),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    app.name.toUpperCase(),
                    style: theme.text.normal.copyWith(
                      fontSize: 11,
                      color: app == this.app
                          ? theme.colors.selectedText
                          : theme.colors.foreground,
                    ),
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
    final theme = OmarchyTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0x88000000), width: 0.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border, width: 2),
        ),
        child: Opacity(opacity: 0.98, child: child),
      ),
    );
  }
}
