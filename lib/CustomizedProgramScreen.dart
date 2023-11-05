import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stayfitdemo/CustomizedPlanScreen2.dart';
import 'package:stayfitdemo/HomeScreen.dart';

class CustomizedPlanScreen extends StatefulWidget {
  final User user;
  final double height;
  final double weight;
  final double bmrWact;

  final TextEditingController _goalWeight = TextEditingController();
  final TextEditingController _startWeight = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  TextEditingController _durationTaken = TextEditingController();

  double currentWeight = 0.0;
  String goalControllerText = '';
  double goalWeightValue = 0.0;

  CustomizedPlanScreen({
    required this.height,
    required this.weight,
    required this.bmrWact, required this.user,
  });

  @override
  _CustomizedPlanScreenState createState() => _CustomizedPlanScreenState();
}

class _CustomizedPlanScreenState extends State<CustomizedPlanScreen> {
  bool _isEditing = true;

  @override
  void initState() {
    super.initState();

    widget._startWeight.text = (widget.weight).toStringAsFixed(1) + ' Kg';

    // Add listeners to controllers
    widget._startWeight.addListener(_startWeightChanged);
    widget._goalWeight.addListener(_goalWeightChanged);
    widget._goalController.addListener(_goalControllerChanged);

    // Set the initial values
    widget.currentWeight = widget.weight;
    widget.goalControllerText = widget._goalController.text;
    widget.goalWeightValue = double.tryParse(widget._goalWeight.text) ?? 0.0;
  }

  void _startWeightChanged() {
    setState(() {
      widget.currentWeight = double.tryParse(widget._startWeight.text) ?? 0.0;
    });
  }

  void _goalWeightChanged() {
    setState(() {
      widget.goalWeightValue = double.tryParse(widget._goalWeight.text) ?? 0.0;
    });
  }

  void _goalControllerChanged() {
    setState(() {
      widget.goalControllerText = widget._goalController.text;
    });
  }

  @override
  void dispose() {
    widget._startWeight.removeListener(_startWeightChanged);
    widget._goalWeight.removeListener(_goalWeightChanged);
    widget._goalController.removeListener(_goalControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._startWeight.text = (widget.weight).toStringAsFixed(1) + ' Kg';


    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).pop();
          },

        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'StayFit',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProductSans'),
            ),
            SizedBox(height: 25),
            Text(
              'Personalize Your Fitness Journey',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProductSans'),
            ),
            SizedBox(height: 25),
            Text(
              'Please share the desired outcomes we should aim for.',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontFamily: 'ProductSans'),
            ),

            SizedBox(height: 40),
            DropdownButtonFormField<String>(
              value: widget.goalControllerText.isNotEmpty
                  ? widget.goalControllerText
                  : null,
              onChanged: (String? newValue) {
                if (newValue == "Weight Loss" ||
                    newValue == "Maintenance" ||
                    newValue == "Weight Gain") {
                  widget._goalController.text = newValue!;
                  if (newValue == "Maintenance") {
                    setState(() {
                      _isEditing = false;
                      widget._goalWeight.text=widget.weight as String;
                      widget._durationTaken.text=1 as String;
                       // Set _isEditing accordingly
                    });
                  }
                  if (newValue == "Weight Loss") {
                    setState(() {
                      _isEditing = true; // Set _isEditing accordingly
                    });
                  }
                  if (newValue == "Weight Gain") {
                    setState(() {
                      _isEditing = true; // Set _isEditing accordingly
                    });
                  }
                }
              },
              items: <String>["Weight Loss", "Maintenance", "Weight Gain"]
                  .map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Your Goal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              validator: (value) {
                if (!["Weight Loss", "Maintenance", "Weight Gain"]
                    .contains(value)) {
                  return 'Please select a valid goal.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: widget._startWeight,
              enabled: _isEditing,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Weight',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),

              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: widget._goalWeight,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goal Weight',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                errorText: validateGoalWeight(widget.goalWeightValue,widget.weight),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: widget._durationTaken,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              validator: (value) {
                if (value != null) {
                  final duration = double.tryParse(value);
                  if (duration != null && duration >= 0 && duration < 730.0) {
                    // Valid duration, less than 2 years (730 days)
                    return null; // No error message
                  } else {
                    // Duration is not valid
                    return 'Duration must be less than 2 years (730 days).';
                  }
                }
                return 'Please enter a valid duration.';
              },
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                if (!_isEditing){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>  CustomizedPlanScreen2 (goalweight: widget.weight,weight: widget.weight,duration: 1,user: widget.user, bmrWact: widget.bmrWact, ),

                    ),

                  );

                }
                else if (widget._goalController.text.isEmpty ||
                    widget._goalWeight.text.isEmpty ||
                    widget._durationTaken.text.isEmpty) {
                  // Show a snackbar error message
                  final snackBar = SnackBar(
                    content: Text('Please fill in all required fields.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  // Check if height and weight are within the specified range
                  final double duration = double.parse(widget._durationTaken.text);
                  final double weight = double.parse(widget._goalWeight.text);
                  final  double gainorloss = (widget.weight-weight).abs();

                  if (duration < 1|| duration > 720) {
                    final snackBar = SnackBar(
                      content: Text('Please enter actual values.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (weight < 35 || weight > 165) {
                    final snackBar = SnackBar(
                      content: Text('Please enter actual values.'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                   if (gainorloss/duration>0.15){//maximum 1kg per week)
                    final snackBar = SnackBar(
                      content: Text('Un-realistic duration entered. Please re-check.\n(Maximum gain/loss is 1kg/Week)'),

                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else {
                    // Save user data to Realtime Database

                    // Navigate to BMIScreen after successful registration
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CustomizedPlanScreen2 (goalweight: weight,weight: widget.weight,duration: duration,user: widget.user, bmrWact: widget.bmrWact, ),
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
    );
  }

  String? validateGoalWeight(double goalWeight, double currentWeight) {
    if (widget.goalControllerText == 'Weight Loss') {
      if (goalWeight >= currentWeight) {
        return 'Goal weight must be less than your current weight.';
      }
    } else if (widget.goalControllerText == 'Weight Gain') {
      if (goalWeight <= currentWeight) {
        return 'Goal weight must be more than your current weight.';
      }
    }
    return null; // Goal weight is valid
  }
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
