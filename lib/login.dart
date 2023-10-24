import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayfitdemo/HomeScreen.dart';
import 'NewUser.dart';
import 'signup.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page with Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCurvedInputField(
              hintText: 'Email',
              prefixIcon: Icons.email,
            ),
            SizedBox(height: 16.0),
            _buildCurvedInputField(
              hintText: 'Password',
              prefixIcon: Icons.lock,
              isPassword: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _signInWithEmail(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 16.0),
            Text(
              'or',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // Handle Google login logic here
              },
              icon: Icon(Icons.g_translate_outlined),
              label: Text('Log In with Google'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navigate to the Sign-Up page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ));
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedInputField({
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: isPassword ? passwordController : emailController,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
      ),
    );
  }

  void _signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Check if it's the first-time login
        bool isFirstTime = await isFirstTimeLogin(user);

        if (isFirstTime) {
          // Navigate to the NewUser screen for first-time users
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NewUser(user: user),
            ),
          );
        }
        else {
          // Navigate to the HomeScreen for returning users
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen2(user: user), // Pass user to HomeScreen
            ),
          );
        }
      }
    } catch (error) {
      // Handle login errors
      print('Error: $error');
      // Show a dialog or a message indicating login failure
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid credentials. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  Future<bool> isFirstTimeLogin(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user's UID is already stored in SharedPreferences
    if (prefs.containsKey(user.uid)) {
      // The user has logged in before
      return false;
    } else {
      // Store the user's UID in SharedPreferences to mark them as logged in
      await prefs.setBool(user.uid, true);
      return true;
    }
  }
// Function to check if the user is logging in for the first time
/*
  Future<bool> isFirstTimeLogin1(User user) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    final id = user.uid;
    final userReference = databaseReference.child('users').child(id).child('firstTimeUser');

    try {
      DatabaseEvent event = await userReference.once();
      DataSnapshot snapshot = event.snapshot;



        if (DatabaseEvent == 1) {
          return true; // It's the first-time login
        }


      return false;
      // User has logged in before
    } catch (error) {
      // Handle Realtime Database errors
      final errorMessage = 'Firebase Realtime Database Error: $error';

      print('Firebase Realtime Database Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 30),
        ),
      );
      return false; // Return false if there's an error
    }
  }*/
}
