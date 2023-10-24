import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MealsScreen extends StatefulWidget {
  final User user;

  MealsScreen({required this.user});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final TextEditingController mealController = TextEditingController();
  int mealsAddedToday = 0;
  Duration timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    checkMealsAddedToday();
    calculateRemainingTime();
  }

  void checkMealsAddedToday() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Check Firestore for the number of meals added today
    final snapshot = await FirebaseFirestore.instance
        .collection('meals')
        .doc(widget.user.uid)
        .collection('daily_meals')
        .where('date', isEqualTo: formattedDate)
        .get();

    setState(() {
      mealsAddedToday = snapshot.size;
    });
  }

  void calculateRemainingTime() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final nextDayStart = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    final remainingDuration = nextDayStart.difference(now);
    setState(() {
      timeRemaining = remainingDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meals Screen'),
      ),
      body: Column(
        children: <Widget>[
          Text('Welcome, ${widget.user.uid}'),
          Text('Current Date: $formattedDate'),
          Text('Meals added today: $mealsAddedToday/5'),
          Text('Time remaining to add a meal: ${timeRemaining.inHours}h ${timeRemaining.inMinutes.remainder(60)}min'),
          TextField(
            controller: mealController,
            decoration: InputDecoration(labelText: 'Enter a meal'),
          ),
          ElevatedButton(
            onPressed: () {
              String meal = mealController.text;

              if (meal.isNotEmpty && mealsAddedToday < 5) {
                final mealDate = formattedDate;
                if (mealDate == formattedDate) {
                  FirebaseFirestore.instance
                      .collection('meals')
                      .doc(widget.user.uid)
                      .collection('daily_meals')
                      .add({
                    'meal': meal,
                    'date': formattedDate,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  mealController.clear();
                  checkMealsAddedToday();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You can only add meals for the current date.'),
                    ),
                  );
                }
              } else if (mealsAddedToday >= 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have reached the daily limit of 5 meals.'),
                  ),
                );
              }
            },
            child: Text('Add Meal'),
          ),
          // Display the user's meals using StreamBuilder
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('meals')
                  .doc(widget.user.uid)
                  .collection('daily_meals')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final meals = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index].data() as Map<String, dynamic>;
                    final mealText = meal['meal'] as String;
                    final mealTimestamp = meal['timestamp'] as Timestamp;

                    return Dismissible(
                      key: Key(meals[index].id), // Use Firestore document ID as key
                      onDismissed: (direction) {
                        // Delete the meal
                        FirebaseFirestore.instance
                            .collection('meals')
                            .doc(widget.user.uid)
                            .collection('daily_meals')
                            .doc(meals[index].id)
                            .delete();
                        checkMealsAddedToday();
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        elevation: 3,
                        child: ListTile(
                          title: Text(mealText),
                          subtitle: Text(
                              'Added on ${mealTimestamp.toDate().toLocal()}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit functionality here
                                  // You can open a dialog or navigate to an edit screen
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Delete the meal
                                  FirebaseFirestore.instance
                                      .collection('meals')
                                      .doc(widget.user.uid)
                                      .collection('daily_meals')
                                      .doc(meals[index].id)
                                      .delete();
                                  checkMealsAddedToday();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
