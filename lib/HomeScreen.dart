import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stayfitdemo/login.dart';
import 'MealsScreen.dart';
import 'account_settings_screen.dart'; // Import the AccountSettingsScreen class
import 'BMIScreen.dart';
import 'package:firebase_core/firebase_core.dart';





class HomeScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
class HomeScreen2 extends StatelessWidget {
  final User user;
  // Receive the user object from the login page

  HomeScreen2({required this.user});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openSideMenu(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _logout(BuildContext context) {
    // Add your logout logic here, such as clearing authentication tokens.
    // For this example, we'll simply navigate to the login screen.
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('StayFit'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _openSideMenu(context),
        ),
      ),
      drawer: Drawer(
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
                // Handle the Home menu item click
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank),
              title: Text('Meals'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => MealsScreen(user: user)));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Handle the Settings menu item click
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: [

              Color.fromRGBO(120, 81, 169,.4), // Blue with 80% opacity
              Color.fromRGBO(55, 202, 206,.8), // Green with 80% opacity
            ],
          ),
        ),
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
    );
  }
}


ButtonStyle customElevatedButtonStyle({
  Color primaryColor = Colors.blue,
  Color textColor = Colors.white,
  double paddingSize = 20.0,
  double borderRadiusSize = 8.0,
}) {
  return ElevatedButton.styleFrom(
    foregroundColor: textColor,
    backgroundColor: primaryColor,
    padding: EdgeInsets.all(paddingSize),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusSize),
    ),
  );
}

