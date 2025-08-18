import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_omarchy/src/config/config.dart';
import 'package:flutter_omarchy/src/theme/text.dart';
import 'package:flutter_omarchy/src/theme/theme.dart';

class Omarchy extends StatefulWidget {
  const Omarchy({super.key, required this.child, this.theme});
  final Widget child;
  final OmarchyThemeData? theme;

  static Future<void> initialize() async {
    final config = OmarchyConfigData.read();
    final text = OmarchyTextStyleData.fromConfig(config);
    await text.loadFonts();
  }

  static OmarchyData of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<OmarchyDataProvider>();
    return inherited!.data;
  }

  @override
  State<Omarchy> createState() => _OmarchyState();
}

class _OmarchyState extends State<Omarchy> {
  late OmarchyData _data;
  StreamSubscription<OmarchyConfigData>? configSubscription;

  void startObservingThemeFromConfig() {
    final config = OmarchyConfigData.read();
    _data = OmarchyData(
      theme: OmarchyThemeData.fromConfig(config),
      config: config,
    );
    configSubscription = OmarchyConfigData.watch().listen(_onConfigChange);
  }

  void stopObservingThemeFromConfig() {
    configSubscription?.cancel();
    configSubscription = null;
  }

  @override
  void initState() {
    super.initState();
    startObservingThemeFromConfig();
  }

  @override
  void dispose() {
    stopObservingThemeFromConfig();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Omarchy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme != oldWidget.theme) {
      if (widget.theme != null) {
        stopObservingThemeFromConfig();
        _data = OmarchyData(theme: widget.theme!, config: _data.config);
      } else {
        startObservingThemeFromConfig();
      }
    }
  }

  void _onConfigChange(OmarchyConfigData config) async {
    final newData = OmarchyData(
      theme: OmarchyThemeData.fromConfig(config),
      config: config,
    );
    await newData.theme.text.loadFonts();
    setState(() {
      _data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OmarchyDataProvider(
      data: _data,
      child: IconTheme(
        data: IconThemeData(size: 18, color: _data.theme.colors.foreground),
        child: DefaultTextStyle(
          style: _data.theme.text.normal.copyWith(
            color: _data.theme.colors.foreground,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class OmarchyDataProvider extends InheritedWidget {
  const OmarchyDataProvider({
    super.key,
    required super.child,
    required this.data,
  });
  final OmarchyData data;

  @override
  bool updateShouldNotify(covariant OmarchyDataProvider oldWidget) {
    return data != oldWidget.data;
  }
}

class OmarchyData {
  const OmarchyData({required this.config, required this.theme});

  final OmarchyConfigData config;
  final OmarchyThemeData theme;
}
