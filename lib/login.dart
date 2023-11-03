import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stayfitdemo/HomeScreen.dart';
import 'NewUser.dart';
import 'signup.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  bool rememberMe = false;
  bool isPasswordVisible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              'Sign in',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Use your StayFit Account',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontFamily: 'ProductSans'),
            ),
            SizedBox(height: 35),
            _buildCurvedInputField2(
              hintText: 'Email',
              prefixIcon: Icons.email, controller: emailController,
            ),
            SizedBox(height: 10.0),
            _buildCurvedInputField(
              hintText: 'Password',
              prefixIcon: Icons.lock,
              isPassword: true, controller: passwordController,
            ),
            // This should be a part of your State

            CheckboxListTile(
              title: Text('Remember Me'),
              value: rememberMe,
              onChanged: (newValue) {
                setState(() {
                  rememberMe = newValue!;
                });
              },
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the Sign-Up page
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ));
                    },
                    child: Text(
                      'Create Account' ,style: TextStyle(
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
                      setState(() {
                        isLoading = true;
                      });

                      _signInWithEmail(
                        emailController.text,
                        passwordController.text,
                        rememberMe,
                      ).then((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    child: Text('Log In',
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

            SizedBox(height: 10.0),

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

                    if (rememberMe) {
                      // Store user preference if "Remember Me" is checked
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('rememberMe', true);
                      // Store other user information if needed
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
      ),
    );
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

  Future<User?>  _signInWithEmail(String email, String password, bool rememberMe) async {
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

        if (rememberMe) {
          // Store user preference if "Remember Me" is checked
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('rememberMe', true);
          // Store other user information if needed
        }
      }
    } catch (error) {
      // Handle login errors
      print('Error: $error');

      final snackBar = SnackBar(
        content: Text('Invalid credentials. Please try again.'),
        duration: Duration(seconds: 5), // Adjust the duration as needed
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Handle the action when the user taps "OK" on the Snackbar
            // This can be left empty or used to perform some action
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
