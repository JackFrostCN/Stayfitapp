// RecommendedProgramScreen.dart
import 'package:flutter/material.dart';

class RecommendedProgramScreen extends StatelessWidget {
  final double? bmiValue; // You need to pass the BMI value from BMIScreen
  final double gainLoss; // values to be passed

  RecommendedProgramScreen({required this.bmiValue,required this.gainLoss});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Program'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              gainLoss.toStringAsFixed(1)+' kg', // Format to one decimal place
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36), // Increase font size
            ),
            SizedBox(height: 16),
            Text(
              'Kilograms to be Gain/Lose',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increase font size
            ),
            SizedBox(height: 16),
            Text(
              'You are currently in the '+_getBMICategory(bmiValue!) + ' category.', // You can define this function to get the category
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Your BMI is ' + bmiValue!.toStringAsFixed(1)+'.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),




          ],
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    // Implement the logic to get the BMI category here
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal Weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }
}
