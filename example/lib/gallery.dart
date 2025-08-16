import 'package:flutter/material.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget selected = sections.last.$2;

  List<(String, Widget)> sections = [
    ('Theme', const ThemePage()),
    ('Widgets', const WidgetsPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return OmarchyScaffold(
      navigationBar: OmarchyNavigationBar(title: Text('Omarchy Gallery')),
      leadingMenu: Menu(
        selected: selected,
        sections: sections,
        onSectionSelected: (value) {
          setState(() {
            selected = value;
          });
        },
      ),
      child: selected,
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key,
    required this.selected,
    required this.sections,
    required this.onSectionSelected,
  });

  final Widget selected;
  final List<(String, Widget)> sections;
  final ValueChanged<Widget> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    return SizedBox(
      width: 200,
      child: ListView(
        children: [
          for (var item in sections)
            OmarchyTile(
              onTap: () {
                onSectionSelected(item.$2);
              },
              title: Text(
                item.$1,
                style: TextStyle(
                  color: item.$2.runtimeType == selected.runtimeType
                      ? omarchy.theme.colors.selectedText
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [Text('Colors'), const SizedBox(height: 12), Colors()],
    );
  }
}

class Colors extends StatelessWidget {
  const Colors({super.key});

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context).theme.colors;
    final base = [
      ('background', omarchy.background),
      ('foreground', omarchy.foreground),
      ('border', omarchy.border),
      ('selectedText', omarchy.selectedText),
    ];
    final normal = [
      ('normal.black', omarchy.normal.black),
      ('normal.white', omarchy.normal.white),
      ('normal.red', omarchy.normal.red),
      ('normal.green', omarchy.normal.green),
      ('normal.blue', omarchy.normal.blue),
      ('normal.cyan', omarchy.normal.cyan),
      ('normal.magenta', omarchy.normal.magenta),
      ('normal.yellow', omarchy.normal.yellow),
    ];
    final bright = [
      ('bright.black', omarchy.bright.black),
      ('bright.white', omarchy.bright.white),
      ('bright.red', omarchy.bright.red),
      ('bright.green', omarchy.bright.green),
      ('bright.blue', omarchy.bright.blue),
      ('bright.cyan', omarchy.bright.cyan),
      ('bright.magenta', omarchy.bright.magenta),
      ('bright.yellow', omarchy.bright.yellow),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        for (var group in [base, normal, bright])
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var (name, color) in group)
                Tooltip(
                  message: name,
                  child: Container(width: 20, height: 20, color: color),
                ),
            ],
          ),
      ],
    );
  }
}

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Logo'),
        const SizedBox(height: 12),
        Align(alignment: Alignment.topLeft, child: OmarchyLogo(width: 200)),
        const SizedBox(height: 24),
        Text('Button'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var color in AnsiColor.values)
              OmarchyButton(
                style: OmarchyButtonStyle.primary(color),
                child: Text('Click me!'),
                onPressed: () {},
              ),
            for (var color in AnsiColor.values)
              OmarchyButton(
                style: OmarchyButtonStyle.primary(color),
                child: Icon(OmarchyIcons.dev.facebook),
                onPressed: () {},
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text('NavigationBar'),
        const SizedBox(height: 12),
        OmarchyNavigationBar(title: Text('Example')),
        const SizedBox(height: 24),
        Text('Tile'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: omarchy.theme.colors.normal.black),
          ),
          child: OmarchyTile(title: Text('Example')),
        ),
        const SizedBox(height: 24),
        Text('Scaffold'),
        const SizedBox(height: 12),
        Container(
          width: 400,
          height: 320,
          decoration: BoxDecoration(
            border: Border.all(color: omarchy.theme.colors.normal.black),
          ),
          child: OmarchyScaffold(
            leadingMenu: Center(child: Text('Leading Menu')),
            status: OmarchyStatusBar(
              leading: [OmarchyStatus(child: Text('Status'))],
            ),
            child: Center(child: Text('Content')),
          ),
        ),
        const SizedBox(height: 24),
        Text('StatusBar'),
        const SizedBox(height: 12),
        OmarchyStatusBar(
          leading: [
            for (var accent in AnsiColor.values)
              OmarchyStatus(
                accent: accent,
                child: Text(accent.name.toUpperCase()),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Tabs'),
        const SizedBox(height: 12),
        OmarchyTabs(
          children: [
            OmarchyTab.closable(
              title: Text('first.dart'),
              onTap: () {},
              onClose: () {},
            ),
            OmarchyTab.closable(
              icon: Icon(Icons.file_copy),
              title: Text('example.dart'),
              onTap: () {},
              onClose: () {},
              isActive: true,
            ),
            for (var i = 0; i < 25; i++)
              OmarchyTab.closable(
                title: Text('example_$i.dart'),
                onTap: () {},
                onClose: () {},
              ),
          ],
        ),
      ],
    );
  }
}
