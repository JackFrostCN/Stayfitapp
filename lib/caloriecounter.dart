import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<dynamic>> csvData = [];
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  TextEditingController amountController = TextEditingController();
  double calories = 0.0;
  String selectedFoodItem = "";

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final String csvString = await rootBundle.loadString('assets/dataset.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

    setState(() {
      csvData = csvTable;
    });
  }

  void calculateCalories(double amountInGrams) {
    final foodRow = csvData.sublist(1).firstWhere((row) {
      return row[1].toString().toLowerCase() == selectedFoodItem.toLowerCase();
    }, orElse: () => []);

    if (foodRow.isNotEmpty && foodRow.length > 3) {
      final double caloriesPer100g = double.tryParse(foodRow[3].toString()) ?? 0.0;
      final double calculatedCalories = (caloriesPer100g * amountInGrams) / 100.0;
      setState(() {
        calories = calculatedCalories;
      });
    } else {
      setState(() {
        calories = 0.0; // Reset to 0 if the food item is not found
      });
    }
  }

  /*void submitToFirebase(String mealId, String foodItem, String amount) {
    FirebaseFirestore.instance
        .collection('meals')
        .doc(widget.user.uid) // Assuming you have a user object
        .collection('daily_meals')
        .doc(mealId)
        .collection('food_items')
        .add({
      'food_item': foodItem,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }*/

  void _showAddFoodItemDialog(String mealId) {
    String foodItem = "";
    String amount = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Food Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (text) {
                  foodItem = text;
                },
                decoration: InputDecoration(labelText: 'Food Item'),
              ),
              TextField(
                onChanged: (text) {
                  amount = text;
                },
                decoration: InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (foodItem.isNotEmpty) {
                  //submitToFirebase(mealId, foodItem, amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calorie Calculator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Select Food Item:'),
              SimpleAutoCompleteTextField(
                key: key,
                controller: TextEditingController(text: selectedFoodItem),
                suggestions: csvData
                    .sublist(1)
                    .map((row) => row[1].toString())
                    .toList(),
                decoration: InputDecoration(
                  hintText: 'Type here',
                ),
                textChanged: (text) {
                  setState(() {
                    selectedFoodItem = text;
                  });
                },
                textSubmitted: (item) {
                  setState(() {
                    selectedFoodItem = item;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Selected Food Item: $selectedFoodItem'), // Display selected food item
              SizedBox(height: 20),
              Text('Enter Amount in Grams:'),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                ),
                onChanged: (text) {
                  final double amountInGrams = double.tryParse(text) ?? 0.0;
                  calculateCalories(amountInGrams);
                },
              ),
              SizedBox(height: 20),
              Text('Calories: $calories'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Open the dialog to add the food item to Firebase
                  _showAddFoodItemDialog("mealId"); // Pass your meal ID here
                },
                child: Text('Add Food Item to Firebase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
