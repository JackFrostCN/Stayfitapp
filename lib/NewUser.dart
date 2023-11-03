import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stayfitdemo/HomeScreen.dart';

import 'NewUser2.dart';


class NewUser1 extends StatefulWidget {
  final User user;

  NewUser1({required this.user});

  @override
  _NewUser1State createState() => _NewUser1State();
}

class _NewUser1State extends State<NewUser1> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                'Create StayFit Account',
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: 'ProductSans'),
              ),
              SizedBox(height: 16),
              Text(
                'Enter your name',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'ProductSans',color: Colors.black54),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: fnameController,
                style: TextStyle(fontSize: 18), // Style for the text entered
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(fontSize: 16), // Style for the label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded border
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: lnameController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              /*TextFormField(
                controller: usernameController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
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
              TextFormField(
                controller: birthdayController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16),*/
              ElevatedButton(
                onPressed: () {
                  if (fnameController.text.isEmpty || lnameController.text.isEmpty) {
                    // Show a snackbar error message
                    final snackBar = SnackBar(
                      content: Text('Please fill in all required fields.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    // Save user data to Realtime Database
                    _saveUserDataToDatabase();
                    // Navigate to HomeScreen after successful registration
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => NewUser2(user: widget.user),
                      ),
                    );
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
      'fname': fnameController.text,
      'lname': lnameController.text,

    };

    // Save the user data to the Realtime Database
    databaseRef.child('users').child(uid).update(userData);
  }
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
