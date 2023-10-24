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
          title: Text('Weight Loss Progress'),
        ),
        body: Center(
          child: WeightLossChart(),
        ),
      ),
    );
  }
}

class WeightLossChart extends StatefulWidget {
  @override
  _WeightLossChartState createState() => _WeightLossChartState();
}

class _WeightLossChartState extends State<WeightLossChart> {
  late double _currentWeight;
  late double _targetWeight;
  late List<Color> gradientColors;
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    _currentWeight = 70.0; // Initial current weight
    _targetWeight = 65.0; // Target weight
    gradientColors = [
      Colors.blue,
      Colors.blueAccent,
    ];
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 37,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                child: LineChart(
                  isShowingMainData ? mainData() : emptyData(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      ),
      minX: 0,
      maxX: 6,
      minY: 65,
      maxY: 70,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, _currentWeight),
            FlSpot(1, 69),
            FlSpot(2, 68),
            FlSpot(3, 67),
            FlSpot(4, 66),
            FlSpot(5, _targetWeight),
            FlSpot(6, 65),
          ],
          isCurved: true,
          colors: gradientColors,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  LineChartData emptyData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 70,
      lineBarsData: [
        LineChartBarData(
          spots: [],
          isCurved: true,
          colors: gradientColors,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}
