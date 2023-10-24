import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blue to Red Progress Bar'),
        ),
        body: Center(
          child: AnimatedProgressBar(targetProgress: 0.7, currentValue: 5),
        ),
      ),
    );
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final double targetProgress;
  final double? currentValue;

  AnimatedProgressBar({required this.targetProgress, required this.currentValue});

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with TickerProviderStateMixin {
  late AnimationController _controller;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // Animation duration of 1.5 seconds
    );

    _controller.addListener(() {
      setState(() {
        _currentProgress = lerpDouble(_currentProgress, widget.targetProgress, _controller.value)!;
      });
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: _currentProgress,
              valueColor: AlwaysStoppedAnimation<Color>(getColorForProgress(_currentProgress)),
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
        SizedBox(height: 16),

      ],
    );
  }

  Color getColorForProgress(double progress) {
    final int red = (255 * progress).toInt();
    final int blue = (255 * (1 - progress)).toInt();
    return Color.fromRGBO(red, 0, blue, 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
