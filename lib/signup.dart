import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCurvedInputField(
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
                ElevatedButton(
                  onPressed: () {
                    _signUpWithEmail(
                      email: emailController.text,
                      password: passwordController.text,
                      scaffoldContext: context,
                    );
                  },
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'or',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    _signInWithGoogle(context);
                  },
                  icon: Icon(Icons.g_translate),
                  label: Text('Sign Up with Google'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                  },
                  child: Text(
                    'Login Instead',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurvedInputField({
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    required TextEditingController controller,
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
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(prefixIcon),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.0),
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
            content: Text('Invalid email address, Recheck the email.'),
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
            content: Text('Password must contain at least 8 characters, including a number, uppercase letter, and a special symbol.'),
            duration: Duration(seconds: 5),
          ),
        );

        return;
      }



      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Create a user profile in the database with the email as the username
        await _database.child(user.uid).set({
          'email': email,
          'username': email,
          'firstTimeUser' : 1,
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

  void _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user != null) {
        // Check if the user is already registered in your Firebase Realtime Database
        // You can use the user.uid to query your database
        // If not registered, you can add the user to the database here

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Successful!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to another page (e.g., login page) after a delay
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign up Failed'),
          content: Text('$errorMessage'),
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
