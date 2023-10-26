import 'dart:ui';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Modern Circular Progress Bar'),
        ),
        body: Center(
          child: AnimatedCircularProgressBar(targetProgress: 0.7, currentValue: 0.5),
        ),
      ),
    );
  }
}

class AnimatedCircularProgressBar extends StatefulWidget {
  final double targetProgress;
  final double? currentValue;

  AnimatedCircularProgressBar({required this.targetProgress, required this.currentValue});

  @override
  _AnimatedCircularProgressBarState createState() => _AnimatedCircularProgressBarState();
}

class _AnimatedCircularProgressBarState extends State<AnimatedCircularProgressBar> with TickerProviderStateMixin {
  late AnimationController _controller;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // 3-second animation duration
    )..addListener(() {
      setState(() {
        _currentProgress = lerpDouble(_currentProgress, widget.targetProgress, _controller.value)!;
      });
    });

    _controller
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: _currentProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(getColorForProgress(_currentProgress)),
            strokeWidth: 20.0, // Increased thickness of the circular progress bar
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Color getColorForProgress(double progress) {
    if (progress <= 0.33) {
      return Colors.blue; // Blue for lower BMI range
    } else if (progress <= 0.66) {
      return Colors.yellow; // Yellow for middle BMI range
    } else {
      return Colors.red; // Red for higher BMI range
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
