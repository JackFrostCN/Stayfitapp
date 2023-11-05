import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'BMIScreen.dart';
import 'HomeScreen.dart';
import 'RecommendedProgramScreen.dart';

class CustomizedPlanScreen2 extends StatefulWidget {
  final User user;
  final double weight;
  final double goalweight;
  final double duration;
  final double bmrWact;
  final TextEditingController _goalController = TextEditingController();
  TextEditingController _carbIntake = TextEditingController(text: '40');
  TextEditingController _proteinIntake = TextEditingController(text: '30');
  TextEditingController _fatIntake = TextEditingController(text: '30');

  double currentWeight = 0.0;
  String goalControllerText = '';
  double goalWeightValue = 0.0;
  bool _isEditing = true;


  CustomizedPlanScreen2({
    required this.goalweight,
    required this.weight,
    required this.duration,
    required this.bmrWact,
    required this.user,
  });


  @override
  State<StatefulWidget> createState() {
    return _CustomizedPlanScreen2State();
  }
}


class _CustomizedPlanScreen2State extends State<CustomizedPlanScreen2> {
  @override
  void initState() {
    super.initState();


    widget._carbIntake.text = '0.4';
    widget._proteinIntake.text = '0.3';
    widget._fatIntake.text = '0.3';

  }
  @override
  Widget build(BuildContext context) {
    double carbAsPer = 0.4;
    double proteinAsPer = 0.3;
    double fatAsPer = 0.3;

    double defORsur = (widget.goalweight - widget.weight) / widget.duration * 7700;
    double dailyCalories = widget.bmrWact + defORsur;
    double carb = dailyCalories * carbAsPer;
    double protein = dailyCalories * proteinAsPer;
    double fat = dailyCalories * fatAsPer;

    void _saveUserDataToDatabase() {
      final databaseRef = FirebaseDatabase.instance.reference();
      final uid = widget.user.uid;

      try {
        double carb = double.parse(widget._carbIntake.text);
        double protein = double.parse(widget._proteinIntake.text);
        double fat = double.parse(widget._fatIntake.text);

        // Convert the calculated values to integers
        int carbInt = (carb * dailyCalories / 100).toInt();
        int proteinInt = (protein * dailyCalories / 100).toInt();
        int fatInt = (fat * dailyCalories / 100).toInt();

        // Create a map of the user data with integer values
        final userData = {
          'carb' : carbInt,
          'protein' : proteinInt,
          'fat' : fatInt,
          'bmract' : dailyCalories.toInt(),
          'dietTitle' : '${widget._goalController.text}',// Convert dailyCalories to integer as well
        };

        // Save the user data to the Realtime Database
        databaseRef.child('users').child(uid).child('userPlan').update(userData);
      } catch (e) {
        // Handle any exceptions or errors that may occur during data conversion or saving
        print('Error saving user data: $e');
        // You can show an error message to the user or perform other error handling as needed
      }
    }




    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StayFit',
          style: TextStyle(
            fontSize: 40,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontFamily: 'ProductSans',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            Text(
              'Crafting Your Health and Diet Strategy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'ProductSans',
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Based on your customization, your daily calorie requirement is ${dailyCalories.toStringAsFixed(0)} cal.",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300.0,
              height: 300.0,
              child: DoughnutChartWithExplode(
                carbPercentage: double.parse(widget._carbIntake.text)/100,
                proteinPercentage: double.parse(widget._proteinIntake.text)/100,
                fatPercentage: double.parse(widget._fatIntake.text)/100,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    label: 'Carbohydrates',
                    controller: widget._carbIntake,
                    borderColor: Color(0xFFF597AF),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextFormField(
                    label: 'Protein',
                    controller: widget._proteinIntake,
                    borderColor: Color(0xFF66B8E7),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextFormField(
                    label: 'Fat',
                    controller: widget._fatIntake,
                    borderColor: Color(0xFFFFD374),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: widget.goalControllerText.isNotEmpty ? widget.goalControllerText : null,
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue == "Muscle Gain with Fat Loss") {
                    widget._carbIntake.text = "30";
                    widget._proteinIntake.text = "45";
                    widget._fatIntake.text = "25";
                    widget._isEditing = false;
                  } else if (newValue == "Balanced Diet (Recommended)") {
                    widget._carbIntake.text = "40";
                    widget._proteinIntake.text = "30";
                    widget._fatIntake.text = "30";
                    widget._isEditing = false;
                  } else if (newValue == "Low-Carb (keto)") {
                    widget._carbIntake.text = "15";
                    widget._proteinIntake.text = "15";
                    widget._fatIntake.text = "70";
                    widget._isEditing = false;
                  } else if (newValue == "Custom") {
                    widget._isEditing = true;
                  }
                  widget._goalController.text = newValue ?? '';
                  widget.goalControllerText = newValue ?? '';
                });
              },
              items: <String>[
                "Muscle Gain with Fat Loss",
                "Balanced Diet (Recommended)",
                "Low-Carb (keto)",
                "Custom",
              ].map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select a Diet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              validator: (value) {
                if (![
                  "Muscle Gain with Fat Loss",
                  "Balanced Diet (Recommended)",
                  "Low-Carb (keto)",
                  "Custom"
                ].contains(value)) {
                  return 'Please select a valid plan.';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: customElevatedButtonStyle(),
              onPressed: () {
                if (widget._carbIntake.text.isEmpty ||
                    widget._proteinIntake.text.isEmpty ||
                    widget._fatIntake.text.isEmpty ||
                widget._goalController.text.isEmpty) {
                  // Show a snackbar error message
                  final snackBar = SnackBar(
                    content: Text('Please fill in all required fields.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  // Check if height and weight are within the specified range
                  final double carb = double.parse(widget._carbIntake.text);
                  final double protein = double.parse(widget._proteinIntake.text);
                  final double fat = double.parse(widget._fatIntake.text);

                  if (carb+protein+fat!=100) {
                    final snackBar = SnackBar(
                      content: Text('Please enter actual values.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (carb<0 || protein<0 || fat<0 || carb>100 || protein>100 ||fat>100) {
                    final snackBar = SnackBar(
                      content: Text('Please enter actual values.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    // Save user data to Realtime Database
                    _saveUserDataToDatabase();
                    // Navigate to BMIScreen after successful registration
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen2(user: widget.user),
                      ),
                    );
                  }
                }
              },
              child: Text("Continue Program"),
            ),
          ],
        ),
      ),
    );

  }

  TextFormField _buildTextFormField({
    String? label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    required Color borderColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      readOnly: !widget._isEditing,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
    );
  }

  ButtonStyle customElevatedButtonStyle({
    Color primaryColor = Colors.white,
    Color textColor = Colors.black87,
    double paddingSize = 15.0,
    double borderRadiusSize = 15.0,
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
      overlayColor: MaterialStateProperty.all<Color>(textColor),
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(color: textColor, width: 2.0),
      ),
    );
  }
}

