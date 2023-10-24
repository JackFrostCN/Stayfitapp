import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class WeightLossChart extends StatefulWidget {
  @override
  _WeightLossChartState createState() => _WeightLossChartState();
}

class _WeightLossChartState extends State<WeightLossChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: 5.0,
          verticalInterval: 1.0,
        ),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            interval: 1.0,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1.0,
          ),
        ),
        minX: 0,
        maxX: 12,
        minY: 65,
        maxY: 80,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 78),
              FlSpot(1, 77),
              FlSpot(2, 76),
              FlSpot(3, 75),
              FlSpot(4, 74),
              FlSpot(5, 73),
              FlSpot(6, 72),
              FlSpot(7, 71),
              FlSpot(8, 70),
              FlSpot(9, 69),
              FlSpot(10, 68),
              FlSpot(11, 67),
              FlSpot(12, 66),
            ],
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
      ),
    );
  }
}
