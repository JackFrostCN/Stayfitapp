import 'package:flutter/material.dart';
import 'package:stayfitdemo/plantab.dart';

import 'home.dart';

class RecommendedProgramScreen extends StatelessWidget {
  final double? bmiValue; // You need to pass the BMI value from BMIScreen
  final double gainLoss;
  final String? gender;
  final int? age;
  final double height;
  final double weight;
  final String selectedActivityLevel; // values to be passed

  RecommendedProgramScreen(
      {required this.bmiValue,
      required this.gainLoss,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.selectedActivityLevel});

  @override
  Widget build(BuildContext context) {
    double bmr = calculateMifflinStJeorBMR(gender!, weight!, height!, age!);
    double bmrWact = calculateBMRWithActivityLevel(bmr, selectedActivityLevel);
    double dailyCalories = CaloriesPerDay(gainLoss, bmrWact);
    double carb = dailyCalories*.4;
    double protein =dailyCalories*.3;
    double fat = dailyCalories*.3;



    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Program'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            plantab(
              carbPercentage: carb,
              proteinPercentage: protein,
              fatPercentage: fat,
              calories: dailyCalories,
            ),
            Text('Gender : $gender '
                '\n$weight kg'
                '\n $height cm'
                '\n age : $age'
                '\n BMR : $bmr'
                '\n BMR with actlvl : $bmrWact'),
            SizedBox(height: 16),
            Text(
              '${gainLoss.toStringAsFixed(1)} kg', // Format to one decimal place
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36), // Increase font size
            ),
            SizedBox(height: 16),
            Text(
              'Kilograms to be ${gainORloss(bmiValue!)} $dailyCalories/day in ${CountDown(gainLoss).toStringAsFixed(0)} days.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'You are currently in the ' +
                  _getBMICategory(bmiValue!) +
                  ' category.', // You can define this function to get the category
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Your BMI is ' + bmiValue!.toStringAsFixed(1) + '.',
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

  String gainORloss(double bmi) {
    if (bmi < 18.5) {
      return 'Gained';
    } else if (bmi < 24.9) {
      return 'Gained';
    } else if (bmi < 24.9) {
      return 'Gained';
    } else if (bmi < 29.9) {
      return 'Lost';
    } else {
      return 'Lost';
    }
  }
}

String gainORloss(double bmi) {
  if (bmi < 18.5) {
    return 'Gained';
  } else if (bmi < 24.9) {
    return 'Gained';
  } else if (bmi < 29.9) {
    return 'Lost';
  } else {
    return 'Lost';
  }
}

double CaloriesPerDay(double gainLoss, double bmr) {
  if (gainLoss < 0) {
    return bmr - 770.0;
  } else {
    return bmr + 770.0;
  }
}

double CountDown(double gainLoss) {
  return gainLoss * 10.0;
}

double calculateMifflinStJeorBMR(
    String gender, double weight, double height, int age) {
  if (gender == 'Male') {
    return 10 * weight + 6.25 * height - 5 * age + 5;
  } else if (gender == 'Female') {
    return 10 * weight + 6.25 * height - 5 * age - 161;
  } else {
    // Handle the case for other genders or provide a default value
    return 0.0; // Or another appropriate default value
  }
}

double calculateBMRWithActivityLevel(double bmr, String selectedActivityLevel) {
  switch (selectedActivityLevel) {
    case 'Sedentary':
      return bmr * 1.2;
    case 'Lightly Active':
      return bmr * 1.375;
    case 'Moderately Active':
      return bmr * 1.55;
    case 'Very Active':
      return bmr * 1.725;
    case 'Super Active':
      return bmr * 1.9;
    default:
      return bmr;
  }
}
