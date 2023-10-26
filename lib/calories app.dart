import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(CaloriesApp());
}

class CaloriesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calories Dashboard'),
        ),
        body: CaloriesDashboard(),
      ),
    );
  }
}

class CaloriesDashboard extends StatefulWidget {
  @override
  _CaloriesDashboardState createState() => _CaloriesDashboardState();
}

class _CaloriesDashboardState extends State<CaloriesDashboard> {
  double totalCalories = 2000.0; // Total daily calorie goal
  double consumedCalories = 1200.0; // Consumed calories
  double remainingCalories = 800.0; // Remaining calories

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedCaloriesDisplay(
            value: totalCalories,
            label: 'Total Calories',
          ),
          SizedBox(height: 16.0),
          AnimatedCaloriesDisplay(
            value: consumedCalories,
            label: 'Consumed Calories',
          ),
          SizedBox(height: 16.0),
          AnimatedCaloriesDisplay(
            value: remainingCalories,
            label: 'Remaining Calories',
          ),
        ],
      ),
    );
  }
}

class AnimatedCaloriesDisplay extends StatefulWidget {
  final double value;
  final String label;

  AnimatedCaloriesDisplay({
    required this.value,
    required this.label,
  });

  @override
  _AnimatedCaloriesDisplayState createState() =>
      _AnimatedCaloriesDisplayState();
}

class _AnimatedCaloriesDisplayState extends State<AnimatedCaloriesDisplay>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentValue = 0.0; // Start from 0
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Animation duration
    );
    _animation = Tween(begin: 0.0, end: widget.value).animate(_animationController)
      ..addListener(() {
        setState(() {
          _currentValue = _animation.value;
        });
      });
    _animationController.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.label,
          style: TextStyle(fontSize: 18.0),
        ),
        CircularPercentIndicator(
          radius: 100.0, // Adjust the size as needed
          lineWidth: 15.0, // Increase the thickness of the circle
          percent: _currentValue / widget.value,
          center: Text(
            (_currentValue / widget.value * 100).toStringAsFixed(1) + "%",
            style: TextStyle(fontSize: 20.0),
          ),
          progressColor: Colors.blue, // Change the progress bar color
          circularStrokeCap: CircularStrokeCap.round, // Rounded corners
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
