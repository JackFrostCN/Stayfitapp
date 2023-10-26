import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Line Chart Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChartSample(),
          ),
        ),
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  final List<double> data = List.generate(10, (index) => Random().nextDouble() * 100);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: const Color(0xff37434d), width: 1),
              left: BorderSide(color: const Color(0xff37434d), width: 1),
              right: BorderSide(color: const Color(0xff37434d), width: 1),
              top: BorderSide(color: const Color(0xff37434d), width: 1),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,

              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
