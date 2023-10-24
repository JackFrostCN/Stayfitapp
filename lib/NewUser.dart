import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stayfitdemo/HomeScreen.dart';
import 'login.dart';

class NewUser extends StatefulWidget {
  final User user;

  NewUser({required this.user});

  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, new user!',
                style: TextStyle(fontSize: 24),
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
              TextFormField(
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save user data to Realtime Database
                  _saveUserDataToDatabase();
                  // Navigate to HomeScreen after registration
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen2(user: widget.user),
                    ),
                  );
                },
                child: Text('Complete Registration'),
              ),

              // Add the "Skip for now" link here
              TextButton(
                onPressed: () {
                  // Navigate to HomeScreen without completing registration
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen2(user: widget.user),
                    ),
                  );
                },
                child: Text('Skip for now'),
              ),
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
      'username2': usernameController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'birthday': birthdayController.text,
    };

    // Save the user data to the Realtime Database
    databaseRef.child('users').child(uid).update(userData);
  }
}
