import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import 'HomeScreen.dart';
import 'MealsScreen.dart';

class CountCal extends StatefulWidget {

  final User user;
  final MealsScreen mealsScreen;


  CountCal({
    Key? key,
    required this.user,
    required this.mealsScreen,
  }) : super(key: key);

  CountCal.withUser({
    required this.user,
  }) : mealsScreen = MealsScreen(user: user), super(key: null);




  @override
  _CountCalState createState() => _CountCalState();


}

class _CountCalState extends State<CountCal> {
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
      final double caloriesPer100g =
          double.tryParse(foodRow[3].toString()) ?? 0.0;
      final double calculatedCalories =
          (caloriesPer100g * amountInGrams) / 100.0;
      setState(() {
        calories = calculatedCalories;
      });
    } else {
      setState(() {
        calories = 0.0; // Reset to 0 if the food item is not found
      });
    }
  }

  void AddFoodItemDialog(String mealId) {
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
              AutoCompleteTextField(
                key: key,
                controller: TextEditingController(text: ''),
                decoration: InputDecoration(
                  labelText: 'Food Item',
                  hintText: 'Enter Food Item',
                ),
                clearOnSubmit: false,
                suggestions:
                csvData.sublist(1).map((row) => row[1].toString()).toList(),
                itemFilter: (item, query) {
                  return item.toLowerCase().contains(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.compareTo(b);
                },
                itemSubmitted: (item) {
                  setState(() {
                    selectedFoodItem = item;
                  });
                },
                itemBuilder: (context, item) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(item),
                  );
                },
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'In grams (g)',
                ),
                onChanged: (text) {
                  final double amountInGrams = double.tryParse(text) ?? 0.0;
                  calculateCalories(amountInGrams);
                },
              ),
              SizedBox(height: 20), // Add some spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle adding to the database here
                      // You can use the values of `selectedFoodItem` and `amountController.text`
                      // to submit the data to the database.
                      Navigator.pop(context);
                    },
                    child: Text('Add to list'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // You can use any icon you want
            color: Colors.blueAccent, // Change the color to your desired color
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => HomeScreen2(user: widget.user)),
              );
            },
          ),
          title: Text('Calorie Calculator'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              AddFoodItemDialog("mealId");
            },
            child: Text('Add Food Item'),
          ),
        ),
      ),
    );
  }
}
