import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMR Calculator',
      home: BMRCalculator(),
    );
  }
}

class BMRCalculator extends StatefulWidget {
  @override
  _BMRCalculatorState createState() => _BMRCalculatorState();
}

class _BMRCalculatorState extends State<BMRCalculator> {
  String selectedGender = 'Male';

  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String selectedActivityLevel = 'Sedentary';

  double calculateMifflinStJeorBMR(String gender, double weight, double height, int age) {
    if (gender == 'Male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  double calculateBMR() {
    String gender = selectedGender;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    int age = int.tryParse(ageController.text) ?? 0;

    return calculateMifflinStJeorBMR(gender, weight, height, age);
  }

  double calculateBMRWithActivityLevel() {
    double bmr = calculateBMR();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMR Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Select Gender:'),
            Row(
              children: [
                Radio(
                  value: 'Male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (cm)'),
            ),
            Text('Select Activity Level:'),
            DropdownButton<String>(
              value: selectedActivityLevel,
              items: [
                DropdownMenuItem(
                  child: Text('bmr'),
                  value: 'bmr',
                ),
                DropdownMenuItem(
                  child: Text('Sedentary'),
                  value: 'Sedentary',
                ),
                DropdownMenuItem(
                  child: Text('Lightly Active'),
                  value: 'Lightly Active',
                ),
                DropdownMenuItem(
                  child: Text('Moderately Active'),
                  value: 'Moderately Active',
                ),
                DropdownMenuItem(
                  child: Text('Very Active'),
                  value: 'Very Active',
                ),
                DropdownMenuItem(
                  child: Text('Super Active'),
                  value: 'Super Active',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedActivityLevel = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                double result = calculateBMRWithActivityLevel();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('BMR Result'),
                      content: Text('Your BMR is $result calories/day.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Calculate BMR'),
            ),
          ],
        ),
      ),
    );
  }
}
