# Flutter Omarchy

[![pub package](https://img.shields.io/pub/v/flutter_omarchy.svg)](https://pub.dev/packages/flutter_omarchy)
[![GitHub Stars](https://img.shields.io/github/stars/aloisdeniel/flutter_omarchy.svg)](https://github.com/aloisdeniel/flutter_omarchy)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package for developing applications for [Omarchy]().

![Omarchy Preview](example/assets/wallpaper.png)

## Introduction

Flutter Omarchy is a specialized UI toolkit designed for building applications that seamlessly integrate with the omarchy.org Archlinux configuration created by DHH. This package bridges the gap between Flutter's powerful development capabilities and the minimalist, terminal-inspired aesthetic of the Omarchy system. With Flutter Omarchy, developers can create applications that not only function within the Omarchy environment but also maintain its distinctive visual style and interaction patterns.

## Quickstart

### Installation

Add Flutter Omarchy to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_omarchy: ^0.1.0
```

Run the following command:
```bash
flutter pub get
```

### Basic Usage

```dart
import 'package:flutter_omarchy/flutter_omarchy.dart';

Future<void> main() async {
  await Omarchy.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      home: OmarchyScaffold(
        body: Center(
          child: OmarchyButton(
            onPressed: () {},
            child: Text('Hello Omarchy!'),
          ),
        ),
      ),
    );
  }
}
```

## Usage

### App Structure

The `OmarchyApp` widget is the root of your application:

```dart
OmarchyApp(
  title: 'My App',
  home: MyHomePage(),
)
```

### Theming

Flutter Omarchy automatically adapts to the system theme of the Omarchy environment, ensuring your application maintains visual consistency with the rest of the system. The package provides a comprehensive design system that follows terminal-inspired aesthetics with monospaced fonts, bordered containers, and a carefully selected color palette. This theming system handles light and dark mode transitions seamlessly, allowing your application to respond to system-wide theme changes without additional configuration.


```dart
final theme = OmarchyTheme.of(context);
```

### Widgets

Omarchy provides a rich set of widgets:

#### Basic Widgets

- `OmarchyScaffold`: Main layout container
- `OmarchyButton`: Terminal-style button
- `OmarchyTextInput`: Text input field
- `OmarchyCheckbox`: Checkbox component
- `OmarchyTile`: List tile component

#### Navigation

- `OmarchyNavigationBar`: Side navigation bar
- `OmarchyTabs`: Tabbed interface
- `OmarchyStatusBar`: Status bar for displaying app state

#### Layout

- `OmarchyBordered`: Container with terminal-style borders
- `OmarchyDivider`: Horizontal or vertical divider
- `OmarchyResizeDivider`: Resizable divider for split views

#### Utility

- `OmarchyTooltip`: Tooltip component
- `OmarchyPopOver`: Popup overlay
- `OmarchyTreeView`: Hierarchical tree view

## Example

The package includes several example applications:

- **Counter**: Simple counter app
- **Calculator**: Basic calculator
- **File Explorer**: Terminal-style file browser
- **Markdown Editor**: Simple markdown editor
- **Pomodoro**: Productivity timer

To run the examples:

```bash
cd example
flutter run --app=pomodoro
```

## Roadmap & Ideas

* Vim motions in text inputs
* Simplified application wide shortcuts configuration
* Preconfigured HJKL shortcuts for navigation
* Specific ormarchy theme configuration (colors, hide nav bar, ...)
* Widgets 
  * Toasts
  * Progress
  * Skeleton
* Examples
  * Todo list
  * AI Chat
  * World clocks
  * Podcast player
  * QRCode generator
  * Password manager
  * Contact book
  * Drawing pad (drawing + text)
  * Raycast-like launcher
  * Calendar
  * Notes app

## How to Contribute

Contributions are welcome! Here's how you can help:

1. **Fork the Repository**: Create your own fork of the project
2. **Create a Branch**: Make your changes in a new branch
3. **Submit a Pull Request**: Open a PR with a clear description of your changes
