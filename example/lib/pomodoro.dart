import 'dart:async';

import 'package:flutter_omarchy/flutter_omarchy.dart';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      debugShowCheckedModeBanner: false,
      home: const PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer>
    with SingleTickerProviderStateMixin {
  // Timer settings
  final int workDuration = 25 * 60; // 25 minutes in seconds
  final int shortBreakDuration = 5 * 60; // 5 minutes in seconds
  final int longBreakDuration = 15 * 60; // 15 minutes in seconds

  // Timer state
  late Timer _timer;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  bool _isWorkPhase = true;
  int _completedWorkPhases = 0;

  // Animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = workDuration;

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _isRunning = false;

          // Switch between work and break phases
          if (_isWorkPhase) {
            _completedWorkPhases++;
            _isWorkPhase = false;

            // After 4 work phases, take a long break
            if (_completedWorkPhases % 4 == 0) {
              _secondsRemaining = longBreakDuration;
            } else {
              _secondsRemaining = shortBreakDuration;
            }
          } else {
            _isWorkPhase = true;
            _secondsRemaining = workDuration;
          }

          // Play notification sound or show notification here
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      _isWorkPhase = true;
      _secondsRemaining = workDuration;
      _completedWorkPhases = 0;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return OmarchyScaffold(
      navigationBar: OmarchyNavigationBar(title: const Text('Pomodoro Timer')),
      status: OmarchyStatusBar(
        leading: [
          OmarchyStatus(
            accent: () {
              if (!_isRunning) {
                return AnsiColor.white;
              }
              if (_isWorkPhase) {
                return AnsiColor.red;
              }
              return AnsiColor.blue;
            }(),
            child: () {
              if (!_isRunning) {
                return Text('PAUSED');
              }
              if (_isWorkPhase) {
                return Text('WORK');
              }
              return Text('BREAK');
            }(),
          ),
        ],
        trailing: [
          OmarchyStatus(
            child: Text('Completed Pomodoros: $_completedWorkPhases'),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isWorkPhase
                ? _buildWorkAnimation(context)
                : _buildBreakAnimation(context),
            const SizedBox(height: 40),
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OmarchyButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: OmarchyButtonStyle.filled(
                    _isWorkPhase ? AnsiColor.red : AnsiColor.blue,
                  ),
                  child: Text(
                    _isRunning ? 'PAUSE' : 'START',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 20),
                OmarchyButton(
                  onPressed: _resetTimer,
                  style: OmarchyButtonStyle.filled(AnsiColor.white),
                  child: const Text('RESET', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Work phase animation - spinning tomato
  Widget _buildWorkAnimation(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 60, color: theme.colors.bright.red),
          ),
        );
      },
    );
  }

  // Break phase animation - pulsing wave
  Widget _buildBreakAnimation(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 60, color: theme.colors.bright.blue),
          ),
        );
      },
    );
  }
}

