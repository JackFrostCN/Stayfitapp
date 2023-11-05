import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dchart.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Modern Circular Progress Bar'),
        ),
        body: Center(
          child: AnimatedCircularProgressBar(targetProgress: 0.7, currentValue: 0.5,bmivalue: 30.0),
        ),
      ),
    );
  }
}
class AnimatedCircularProgressBar extends StatefulWidget {
  final double targetProgress;
  final double? currentValue;
  final double? bmivalue;

  AnimatedCircularProgressBar({
    required this.targetProgress,
    required this.currentValue,
    required this.bmivalue,
  });

  @override
  _AnimatedCircularProgressBarState createState() =>
      _AnimatedCircularProgressBarState();
}

class _AnimatedCircularProgressBarState
    extends State<AnimatedCircularProgressBar>
    with TickerProviderStateMixin {
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
        _currentProgress =
        lerpDouble(_currentProgress, widget.targetProgress, _controller.value)!;
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
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: _currentProgress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                    getColorForProgress(_currentProgress)),
                strokeWidth: 20.0, // Increased thickness of the circular progress bar
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.bmivalue?.toStringAsFixed(1)}", // Display the BMI value
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'ProductSans'),
                ),
                Text(
                  "BMI",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'ProductSans'),
                ),
              ],
            ),
          ],
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

class DoughnutChartWithExplode extends StatelessWidget {
  final double carbPercentage;
  final double proteinPercentage;
  final double fatPercentage;

  DoughnutChartWithExplode({
    required this.carbPercentage,
    required this.proteinPercentage,
    required this.fatPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(


      series: <CircularSeries>[
        DoughnutSeries<Data, String>(

          dataSource: <Data>[
            Data(
              'Carbohydrates',
              carbPercentage,
            ),
            Data('Protein', proteinPercentage),
            Data('Fat', fatPercentage),
          ],
          xValueMapper: (Data data, _) => data.segment,
          yValueMapper: (Data data, _) => data.value,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
            labelPosition: ChartDataLabelPosition.outside,
            labelIntersectAction: LabelIntersectAction.none,
            textStyle: TextStyle(fontSize: 10),
          ),
          explode: true,
          pointColorMapper: (Data data, _) {
            if (data.segment == 'Carbohydrates') {
              return const Color(0xFFF597AF);
            } else if (data.segment == 'Protein') {
              Colors.transparent;
            } else if (data.segment == 'Fat') {
              Colors.transparent;
            }
            return Colors.transparent;
          },
          // This line will explode the segment
        ),
      ],

    );
  }
}
