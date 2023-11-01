import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Explode Doughnut Chart Example'),
        ),
        body: Center(
          child: DoughnutChartWithExplode(),
        ),
      ),
    );
  }
}

class DoughnutChartWithExplode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: <CircularSeries>[
        DoughnutSeries<Data, String>(
          dataSource: <Data>[
            Data('Segment 1', 30),
            Data('Segment 2', 20),
            Data('Segment 3', 40),
            Data('Segment 4', 10),
          ],
          xValueMapper: (Data data, _) => data.segment,
          yValueMapper: (Data data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          explode: true, // This line will explode the segment
        ),
      ],
    );
  }
}

class Data {
  Data(this.segment, this.value);

  final String segment;
  final double value;
}
