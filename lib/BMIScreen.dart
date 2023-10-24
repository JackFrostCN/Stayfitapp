import 'package:flutter/material.dart';
import 'CustomizedProgramScreen.dart';

import 'HomeScreen.dart';
import 'RecommendedProgramScreen.dart';
import 'd.dart';

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  double _height = 175.0; // Predefined height in centimeters
  double _weight = 70.0; // Predefined weight in kilograms
  double? _bmiResult;
  String _bmiCategory = '';





  @override
  Widget build(BuildContext context) {
    _calculateBMI();
    double F = (_bmiResult!- 15) / (32 - 15);

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            Text(
              'Height: $_height cm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increase font size
            ),
            SizedBox(height: 16),
            Text(
              'Weight: $_weight kg',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Increase font size
            ),
            SizedBox(height: 50),
            AnimatedProgressBar(targetProgress: F , currentValue: _bmiResult),
            SizedBox(height: 50),

            _bmiResult != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$_bmiResult',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80), // Increase BMI font size
                ),
                Text(
                  'BMI',
                  style: TextStyle(fontSize: 20), // Increase font size
                ),

                SizedBox(height: 100),
                // Inside the build method of BMIScreen
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecommendedProgramScreen(bmiValue: _bmiResult, gainLoss: _calculateKilogramsToGoal()),
                      ),
                    );
                  },
                  style: customElevatedButtonStyle(),
                  child: Text(
                    'Recommended Program',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  'OR',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CustomPlanScreen(),
                      ),
                    );
                  },
                  style: customElevatedButtonStyle(),
                  child: Text(
                    'Start user customized program',
                    style: TextStyle(fontSize: 18),
                  ),
                ),


              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _calculateBMI() {
    double heightInMeters = _height / 100;
    double bmi = _weight / (heightInMeters * heightInMeters);

    setState(() {
      _bmiResult = double.parse(bmi.toStringAsFixed(1));
      _bmiCategory = _getBMICategory(bmi);
    });
  }

  String _getBMICategory(double bmi) {
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


  double _calculateKilogramsToGoal() {
    double heightInMeters = _height / 100;
    double idealBMI;

    switch (_bmiCategory) {
      case 'Underweight':
        idealBMI = 18.5;

        break;
      case 'Normal Weight':
        idealBMI = 24.9;
        break;
      case 'Overweight':
        idealBMI = 29.9;
        break;
      default:
        idealBMI = 24.9; // Default to Normal Weight
    }

    double idealWeight = idealBMI * heightInMeters * heightInMeters;
    double kilogramsToGoal = idealWeight - _weight;

    return kilogramsToGoal;
  }
}
