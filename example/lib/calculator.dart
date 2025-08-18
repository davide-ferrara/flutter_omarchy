import 'package:flutter_omarchy/flutter_omarchy.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  static const buttonSpacing = 14.0;

  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _currentValue = '';
  String _operation = '';
  double _firstOperand = 0;
  bool _clearOnNextInput = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_clearOnNextInput) {
        _display = digit;
        _clearOnNextInput = false;
      } else {
        _display = _display == '0' ? digit : _display + digit;
      }
      _currentValue = _display;
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      _firstOperand = double.parse(_display);
      _operation = operation;
      _clearOnNextInput = true;
    });
  }

  void _onEqualsPressed() {
    if (_operation.isEmpty) return;

    final secondOperand = double.parse(_currentValue);
    double result;

    switch (_operation) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        result = _firstOperand / secondOperand;
        break;
      default:
        return;
    }

    setState(() {
      _display = result.toString();
      if (_display.endsWith('.0')) {
        _display = _display.substring(0, _display.length - 2);
      }
      _operation = '';
      _clearOnNextInput = true;
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _currentValue = '';
      _operation = '';
      _firstOperand = 0;
      _clearOnNextInput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return OmarchyScaffold(
      navigationBar: const OmarchyNavigationBar(title: Text('Calculator')),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colors.normal.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: theme.colors.border),
              ),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Column(
                spacing: CalculatorApp.buttonSpacing,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Row(
                      spacing: CalculatorApp.buttonSpacing,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(
                          '7',
                          onPressed: () => _onDigitPressed('7'),
                        ),
                        CalculatorButton(
                          '8',
                          onPressed: () => _onDigitPressed('8'),
                        ),
                        CalculatorButton(
                          '9',
                          onPressed: () => _onDigitPressed('9'),
                        ),
                        CalculatorButton(
                          '÷',
                          onPressed: () => _onOperationPressed('÷'),
                          color: AnsiColor.cyan,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: CalculatorApp.buttonSpacing,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(
                          '4',
                          onPressed: () => _onDigitPressed('4'),
                        ),
                        CalculatorButton(
                          '5',
                          onPressed: () => _onDigitPressed('5'),
                        ),
                        CalculatorButton(
                          '6',
                          onPressed: () => _onDigitPressed('6'),
                        ),
                        CalculatorButton(
                          '×',
                          onPressed: () => _onOperationPressed('×'),
                          color: AnsiColor.cyan,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: CalculatorApp.buttonSpacing,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(
                          '1',
                          onPressed: () => _onDigitPressed('1'),
                        ),
                        CalculatorButton(
                          '2',
                          onPressed: () => _onDigitPressed('2'),
                        ),
                        CalculatorButton(
                          '3',
                          onPressed: () => _onDigitPressed('3'),
                        ),
                        CalculatorButton(
                          '-',
                          onPressed: () => _onOperationPressed('-'),
                          color: AnsiColor.cyan,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: CalculatorApp.buttonSpacing,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(
                          'C',
                          onPressed: _onClearPressed,
                          color: AnsiColor.red,
                        ),
                        CalculatorButton(
                          '0',
                          onPressed: () => _onDigitPressed('0'),
                        ),
                        CalculatorButton(
                          '=',
                          onPressed: _onEqualsPressed,
                          color: AnsiColor.green,
                        ),
                        CalculatorButton(
                          '+',
                          onPressed: () => _onOperationPressed('+'),
                          color: AnsiColor.cyan,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.color = AnsiColor.white,
  });

  final String text;
  final VoidCallback onPressed;
  final AnsiColor color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OmarchyButton(
        style: OmarchyButtonStyle.filled(color),
        onPressed: onPressed,
        child: Center(child: Text(text, style: TextStyle(fontSize: 32))),
      ),
    );
  }
}

