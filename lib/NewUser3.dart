import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'BMIScreen.dart';
import 'NewUser2.dart';

class NewUser3 extends StatefulWidget {
  final User user;

  NewUser3({required this.user});

  @override
  _NewUser3State createState() => _NewUser3State();
}

class _NewUser3State extends State<NewUser3> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  TextEditingController _actlvlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewUser2(user: widget.user), // Pass the user object
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'StayFit',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProductSans'),
              ),
              SizedBox(height: 35),
              Text(
                'Almost There',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProductSans'),
              ),
              SizedBox(height: 16),
              Text(
                'Enter your hight, weight & activity Level',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontFamily: 'ProductSans'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: heightController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number, // Numeric keyboard
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: weightController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextFormFieldActivityLevel(label: 'Activity Level', controller: _actlvlController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (weightController.text.isEmpty ||
                      heightController.text.isEmpty ||
                      _actlvlController.text.isEmpty) {
                    // Show a snackbar error message
                    final snackBar = SnackBar(
                      content: Text('Please fill in all required fields.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    // Check if height and weight are within the specified range
                    final double height = double.parse(heightController.text);
                    final double weight = double.parse(weightController.text);

                    if (height < 100 || height > 220) {
                      final snackBar = SnackBar(
                        content: Text('Please enter actual values.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (weight < 35 || weight > 165) {
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
                          builder: (context) => BMIScreen(user: widget.user),
                        ),
                      );
                    }
                  }
                },

                child: Text('Next'),
                style: customElevatedButtonStyle(),
              )

            ],
          ),
        ),
      ),
    );
  }

  void _saveUserDataToDatabase() {
    final databaseRef = FirebaseDatabase.instance.reference();
    final uid = widget.user.uid;

    // Create a map of the user data to save to the Realtime Database
    final userData = {
      'weight': weightController.text,
      'height': heightController.text,
      'actlvl' : _actlvlController.text,
    };

    // Save the user data to the Realtime Database
    databaseRef.child('users').child(uid).update(userData);
  }
}
Widget _buildTextFormFieldActivityLevel({
  required String label,
  required TextEditingController controller,
  bool enabled = true, // Specify if the field is editable
}) {
  return DropdownButtonFormField<String>(
    value: controller.text.isNotEmpty ? controller.text : null,

    onChanged:
         (String? newValue) {
      if (newValue == "Sedentary" ||
          newValue == "Lightly Active" ||
          newValue == "Moderately Active" ||
          newValue == "Very Active" ||
          newValue == "Super Active") {
        controller.text = newValue!;
      }
    }
        , // Set to null when not editing

    items: <String>[
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
      'Super Active'
    ].map((String option) {
      return DropdownMenuItem<String>(
        value: option,
        child: Text(option),
      );
    }).toList(),
    decoration: InputDecoration(
      labelText: label,
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
        'Sedentary',
        'Lightly Active',
        'Moderately Active',
        'Very Active',
        'Super Active'
      ].contains(value)) {
        return 'Please select a valid activity level.';
      }
      return null;
    },
  );
}

ButtonStyle customElevatedButtonStyle({
  Color primaryColor = Colors.white,
  Color textColor = Colors.black87,
  double paddingSize = 10.0,
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
