import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'CustomizedProgramScreen.dart';
import 'RecommendedProgramScreen.dart';
import 'd.dart';

class BMIScreen extends StatefulWidget {
  final User user;

  BMIScreen({required this.user});

  @override
  _BMIScreenState createState() => _BMIScreenState(user: user);
}

class _BMIScreenState extends State<BMIScreen> {
  final User user;
  double _height = 175.0; // Predefined height in centimeters
  double _weight = 70.0;
  String _birthday = '0';
  int _age = 0;
  String _gender = '';
  String _actlvl = '';//
  double? _bmiResult;
  String _bmiCategory = '';

  final databaseRef = FirebaseDatabase.instance.reference();
  _BMIScreenState({required this.user});

  @override
  void initState() {
    super.initState();
    final userId = widget.user.uid;
    // Retrieve height and weight from Firebase
    databaseRef
        .child('users')
        .child(userId)
        .child('height')
        .onValue
        .listen((heightEvent) {
      if (heightEvent.snapshot.value != null) {
        final height = double.parse(heightEvent.snapshot.value.toString());
        setState(() {
          _height = height;
        });
      }
    });

    databaseRef
        .child('users')
        .child(userId)
        .child('weight')
        .onValue
        .listen((weightEvent) {
      if (weightEvent.snapshot.value != null) {
        final weight = double.parse(weightEvent.snapshot.value.toString());
        setState(() {
          _weight = weight;
        });
      }
    });
    //revive gender
    databaseRef
        .child('users')
        .child(userId)
        .child('gender')
        .onValue
        .listen((genderEvent) {
      if (genderEvent.snapshot.value != null) {
        final gender = genderEvent.snapshot.value.toString();
        setState(() {
          _gender = gender;
        });
      }
    });
    //revive actlvl
    databaseRef
        .child('users')
        .child(userId)
        .child('actlvl')
        .onValue
        .listen((actlvlEvent) {
      if (actlvlEvent.snapshot.value != null) {
        final actlvl = actlvlEvent.snapshot.value.toString();
        setState(() {
          _actlvl = actlvl;
        });
      }
    });
    //revive birthday
    databaseRef
        .child('users')
        .child(userId)
        .child('birthday')
        .onValue
        .listen((birthdayEvent) {
      if (birthdayEvent.snapshot.value != null) {
        final birthday = birthdayEvent.snapshot.value.toString();
        setState(() {
          _birthday = birthday;
          _age = calculateAge(_birthday);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculateBMI();
    double F = (_bmiResult! - 15) / (32 - 15);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // back button

        title: Text(
          'Your BMI Details',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black, // Set the text color to black
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Height: $_height cm | Weight: $_weight kg',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20), // Increase font size
            ),
            SizedBox(height: 16),
            Text(
              'Gender: $_gender | Age : $_age | Activity Level : $_actlvl',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20), // Increase font size
            ),
            SizedBox(height: 50),
            AnimatedCircularProgressBar(
                targetProgress: F, currentValue: _bmiResult),
            SizedBox(height: 50),
            _bmiResult != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$_bmiResult',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 80), // Increase BMI font size
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
                              builder: (context) => RecommendedProgramScreen(
                                  bmiValue: _bmiResult,
                                  gainLoss: _calculateKilogramsToGoal(),
                                  gender: _gender,
                                  age: _age,
                                  height: _height,
                                  weight: _weight,
                              selectedActivityLevel: _actlvl),
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
    double idealBMI = 24.9;

    double idealWeight = idealBMI * heightInMeters * heightInMeters;
    double kilogramsToGoal = idealWeight - _weight;

    return kilogramsToGoal;
  }
}

ButtonStyle customElevatedButtonStyle({
  Color primaryColor = Colors.white,
  Color textColor = Colors.black,
  double paddingSize = 15.0,
  double borderRadiusSize = 10.0,
}) {
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.all(paddingSize),
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSize),
      ),
    ),
    overlayColor: MaterialStateProperty.all<Color>(
        textColor), // Changes the color of the button when pressed
    side: MaterialStateProperty.all<BorderSide>(
      BorderSide(color: textColor, width: 2.0), // Defines the stroke (border)
    ),
  );
}

int calculateAge(String dateText) {
  // Parse the date from the "dd/mm/yyyy" format
  final List<String> parts = dateText.split('/');
  if (parts.length != 3) {
    // Handle invalid date format
    return 0;
  }

  final int day = int.parse(parts[0]);
  final int month = int.parse(parts[1]);
  final int year = int.parse(parts[2]);

  // Get the current date
  final DateTime now = DateTime.now();

  // Calculate the difference in years
  int age = now.year - year;

  // Adjust the age if the birthdate hasn't occurred yet this year
  if (month > now.month || (month == now.month && day > now.day)) {
    age--;
  }

  return age;
}
