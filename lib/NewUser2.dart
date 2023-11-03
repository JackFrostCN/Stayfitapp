import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'NewUser.dart';
import 'NewUser3.dart';

class NewUser2 extends StatefulWidget {
  final User user;

  NewUser2({required this.user});

  @override
  _NewUser2State createState() => _NewUser2State();
}

class _NewUser2State extends State<NewUser2> {
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

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
                builder: (context) => NewUser1(user: widget.user), // Pass the user object
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,

      ),

        body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                'Basic information',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ProductSans'),
              ),
              SizedBox(height: 16),
              Text(
                'Enter your birthday and gender',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontFamily: 'ProductSans'),
              ),
              SizedBox(height: 40),
              _buildTextFormFieldSelectDate(
                label: 'Birthday',
                controller: birthdayController,
                context: context,
              ),
              SizedBox(height: 20),
              _buildTextFormFieldGender(
                label: 'Gender',
                controller: _genderController,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (birthdayController.text.isEmpty || _genderController.text.isEmpty) {
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
                        builder: (context) => NewUser3(user: widget.user),
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
      'birthday': birthdayController.text,
      'gender': _genderController.text,
    };

    // Save the user data to the Realtime Database
    databaseRef.child('users').child(uid).update(userData);
  }
}

TextFormField _buildTextFormFieldSelectDate({
  String? label,
  TextInputType? keyboardType,
  required BuildContext context,
  TextEditingController? controller, // Add a dateController parameter
}) {
  return TextFormField(
    controller: controller,
    readOnly: true,
    keyboardType: keyboardType,
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
    onTap: () {
      _selectDate(context,
          controller); // Pass the dateController to the _selectDate function
    },
  );
}

Widget _buildTextFormFieldGender({
  required String label,
  required TextEditingController controller,
  bool enabled = true, // Specify if the field is editable
}) {
  return DropdownButtonFormField<String>(
    value: controller.text.isNotEmpty ? controller.text : null,


    onChanged: (String? newValue) {
      if (newValue == "Male" || newValue == "Female") {
        controller.text = newValue!;
      }
    },
    // Set to null when not editing

    items: <String>['Male', 'Female'].map((String option) {
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
      if (value != "Male" && value != "Female") {
        return 'Please select either Male or Female.';
      }
      return null;
    },
  );
}

Future<void> _selectDate(
    BuildContext context, TextEditingController? dateController) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null && dateController != null) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
    dateController.text = formattedDate;
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
