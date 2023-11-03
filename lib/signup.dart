import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'NewUser.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup Page with Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('users');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? errorMessage;

  bool isPasswordVisible = false; // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20.0),
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
                  "Let's Get Started!",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ProductSans'),
                ),
                SizedBox(height: 20),
                Text(
                  'Create your Account',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontFamily: 'ProductSans'),
                ),
                SizedBox(height: 35),
                _buildCurvedInputField2(
                  hintText: 'Email',
                  prefixIcon: Icons.email,
                  controller: emailController,
                ),
                SizedBox(height: 16.0),
                _buildCurvedInputField(
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  controller: passwordController,
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                        },
                        child: Text(
                            'I already have an account' ,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ProductSans',
                        )
                        ),
                      ),
                    ),

                    SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _signUpWithEmail(
                            email: emailController.text,
                            password: passwordController.text,
                            scaffoldContext: context,
                          );
                        },
                        child: Text('Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ProductSans',
                            )),
                        style: customElevatedButtonStyle(),
                      ),
                    ),
                    // Add some spacing between the buttons
                  ],
                ),

                SizedBox(height: 16.0),
                Card(
                  child: TextButton(
                    onPressed: () async {
                      User? user = await _signInWithGoogle();

                      if (user != null) {
                        // Check if it's the first-time login
                        bool isFirstTime = await isFirstTimeLogin(user);

                        if (isFirstTime) {
                          // Navigate to the NewUser screen for first-time users
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => NewUser1(user: user),
                            ),
                          );
                        } else {
                          // Navigate to the HomeScreen for returning users
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen2(user: user), // Pass user to HomeScreen
                            ),
                          );
                        }


                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove padding around the button
                      minimumSize: Size(0, 0), // Set the minimum button size to zero
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove extra padding
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue, // Set the border color to blue
                          width: 1.0, // Adjust the border width as needed
                        ),
                        borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Add some padding around the content
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google_logo.png', // Replace with the actual path to your custom Google logo image
                              width: 24, // Adjust the width and height to match your image size
                              height: 24,
                            ),
                            Padding(padding: const EdgeInsets.all(5.0),),
                            Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'ProductSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
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
  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign-In process
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      return user;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  Widget _buildCurvedInputField({
    required String hintText,
    required IconData prefixIcon,
    required isPassword,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: TextStyle(fontSize: 16), // Style for the label
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Rounded border
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCurvedInputField2({
    required String hintText,
    required IconData prefixIcon,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(fontSize: 16), // Style for the label
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded border
          ),
        ),
      ),
    );
  }

  Future<void> _signUpWithEmail({
    required String email,
    required String password,
    required BuildContext scaffoldContext,
  }) async {
    try {
      if (!_isEmailValid(email)) {
        // Email is not in the correct format
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Invalid email address, Please re-check.'),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }
      // Check if the password meets the criteria
      if (!_isPasswordValid(password)) {
        // Password does not meet the criteria
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text(
                'Password must contain at least 8 characters, including a number, uppercase letter, and a special symbol.'),
            duration: Duration(seconds: 5),
          ),
        );

        return;
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        int atIndex = email.indexOf('@');
        String username = atIndex != -1 ? email.substring(0, atIndex) : email;
        // Create a user profile in the database with the email as the username
        await _database.child(user.uid).set({
          'email': email,
          'username': username,
          // Set the username to the email
        });

        // Show success message
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            content: Text('Registration Successful!'),
            duration: Duration(seconds: 5),
          ),
        );

        // Navigate to another page (e.g., login page) after a delay
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(scaffoldContext).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('This email is already registered!'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }


}

bool _isPasswordValid(String password) {
  // Add your password validation logic here
  final RegExp passwordPattern = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );
  return passwordPattern.hasMatch(password);
}

bool _isEmailValid(String email) {
  // Use a regular expression to validate the email format
  final emailPattern = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  // Test the email against the pattern
  return emailPattern.hasMatch(email);
}

ButtonStyle customElevatedButtonStyle({
  Color primaryColor = Colors.blue,
  Color textColor = Colors.white,
  double paddingSize = 15.0,
  double borderRadiusSize = 5.0,
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
      BorderSide(color: textColor, width: 0.0),
    ),
  );
}
