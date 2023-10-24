import 'package:flutter/material.dart';
import 'package:stayfitdemo/HomeScreen.dart';

class CustomPlan {
  double weight;
  int durationMonths;

  CustomPlan(this.weight, this.durationMonths);
}

class CustomPlanScreen extends StatefulWidget {
  @override
  _CustomPlanScreenState createState() => _CustomPlanScreenState();
}

class _CustomPlanScreenState extends State<CustomPlanScreen> {
  final TextEditingController _weightController = TextEditingController();
  int _selectedDuration = 1; // Default duration is 1 month
  String _selectedOption = 'Weight Gain'; // Default option

  final List<int> durations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 18, 24]; // Durations in months

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Plan Creator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create Your Custom Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Radio<String>(
                  value: 'Weight Gain',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                ),
                Text('Weight Gain'),
                Radio<String>(
                  value: 'Maintenance',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                ),
                Text('Maintenance'),
                Radio<String>(
                  value: 'Weight Loss',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                ),
                Text('Weight Loss'),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: _selectedDuration,
              onChanged: (newValue) {
                setState(() {
                  _selectedDuration = newValue!;
                });
              },
              items: durations.map((duration) {
                return DropdownMenuItem<int>(
                  value: duration,
                  child: Text('$duration months'),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Duration',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double weight = double.tryParse(_weightController.text) ?? 0.0;
                CustomPlan customPlan = CustomPlan(weight, _selectedDuration);
                // You can now use the customPlan object and _selectedOption to create the custom plan.
                print('Selected Option: $_selectedOption');
                print('Weight: ${customPlan.weight} kg');
                print('Duration: ${customPlan.durationMonths} months');
                // Add logic to create the custom plan here.
              },
              style: customElevatedButtonStyle(),
              child: Text('Create Custom Plan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Plan Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomPlanScreen(),
    );
  }
}
