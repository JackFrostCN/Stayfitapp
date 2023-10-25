import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stayfitdemo/login.dart';
import 'MealsScreen.dart';
import 'account_settings_screen.dart'; // Import the AccountSettingsScreen class
import 'BMIScreen.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen2 extends StatelessWidget {
  final User user;

  HomeScreen2({required this.user});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  Image getGreetingSymbol() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return Image.asset('assets/gm.png'); // Replace 'sun.png' with the actual image asset path
    } else if (hour < 17) {
      return Image.asset('assets/ga.png'); // Replace 'cloud.png' with the actual image asset path
    } else {
      return Image.asset('assets/ge.png'); // Replace 'moon.png' with the actual image asset path
    }
  }

  void _openSideMenu(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            getGreeting(),
            style: TextStyle(
              fontSize: 36,
              color: Colors.black, // Set the text color to black
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.person_3_rounded),
            color: Colors.black,
            onPressed: () => _openSideMenu(context),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getGreetingSymbol(),
                ),
              ],
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0.0, // Remove the divider
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(user.uid),
                  accountEmail: Text(user.email!),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_picture.png'),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.food_bank),
                  title: Text('Meals'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MealsScreen(user: user)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/hh.png',
                  width: 1000, // Adjust the width as needed
                  height: 500, // Adjust the height as needed
                ),
                SizedBox(height: 20), // Add spacing below the image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AccountSettingsScreen(user: user,)));
                      },
                      style: customElevatedButtonStyle(),
                      child: Text('Account'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle the "Tips" button click
                      },
                      style: customElevatedButtonStyle(),
                      child: Text('Tips'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BMIScreen(user: user,)));
                      },
                      style: customElevatedButtonStyle(),
                      child: Text('BMI'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ButtonStyle customElevatedButtonStyle({
  Color primaryColor = Colors.white,
  Color textColor = Colors.black,
  double paddingSize = 15.0,
  double borderRadiusSize = 10.0,
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
    overlayColor: MaterialStateProperty.all<Color>(textColor), // Changes the color of the button when pressed
    side: MaterialStateProperty.all<BorderSide>(
      BorderSide(color: textColor, width: 2.0), // Defines the stroke (border)
    ),
  );
}
