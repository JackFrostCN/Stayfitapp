import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
void main() {
  runApp(plancal());
}
class plancal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your App Title'),
        ),
        body: plantab(
          carbPercentage: 40.0,  // Provide appropriate values here
          proteinPercentage: 30.0,
          fatPercentage: 20.0,
          calories: 500.0,
        ),
      ),
    );
  }
}


class plantab extends StatelessWidget {

  final double carbPercentage;
  final double proteinPercentage;
  final double fatPercentage;
  final double calories;

  plantab({
    required this.carbPercentage,
    required this.proteinPercentage,
    required this.fatPercentage,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          elevation: 0, // Add elevation for a card effect
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$calories'),
                DoughnutChartWithExplode(
                  carbPercentage: carbPercentage,
                  proteinPercentage: proteinPercentage ,
                  fatPercentage: fatPercentage,
                ),
                SizedBox(
                    height:
                    10), // Add vertical spacing between the chart and squares
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColoredSquare(
                        color: Color(0xFFF597AF), label: 'Carbohydrates'),
                    ColoredSquare(color: Color(0xFFFFD374), label: 'Fats'),
                    ColoredSquare(color: Color(0xFF66B8E7), label: 'Protein'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            labelIntersectAction: LabelIntersectAction.none,
            textStyle: TextStyle(fontSize: 10),
          ),
          explode: true,
          pointColorMapper: (Data data, _) {
            if (data.segment == 'Carbohydrates') {
              return const Color(0xFFF597AF);
            } else if (data.segment == 'Protein') {
              return const Color(0xFF66B8E7);
            } else if (data.segment == 'Fat') {
              return const Color(0xFFFFD374);
            }
            return Colors.transparent;
          },
          // This line will explode the segment
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x: point.y%', // Customize the tooltip format as needed
      ),
    );
  }
}

class Data {
  Data(this.segment, this.value);

  final String segment;
  final double value;
}

class ColoredSquare extends StatelessWidget {
  final Color color;
  final String label;

  ColoredSquare({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
        ),
        // Add some spacing
        Text(
          label,
          style: TextStyle(
            color: Colors.black, // Text color
            fontWeight: FontWeight.bold, // Customize text style as needed
          ),
        ),
      ],
    );
  }

}
