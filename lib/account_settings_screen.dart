
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';


class AccountSettingsScreen extends StatefulWidget {

  final User user;

  AccountSettingsScreen({required this.user});
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState(user: user);
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final User user;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  _AccountSettingsScreenState({required this.user});
  String _name = '';
  String _email = 'stayfit@demo.com';
  String _password = 'password123'; // Initial password
  String _birthday = '01/01/1990';
  double _height = 175.0; // Initial height in centimeters
  double _weight = 70.0; // Initial weight in kilograms
  String _username = 'pkyy';
  bool _isPasswordVisible = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final databaseRef = FirebaseDatabase.instance.reference();
    final id = widget.user.uid;


// Retrieve fname from Firebase
    databaseRef.child('users').child(id).child('fname').onValue.listen((fnameEvent) {
      if (fnameEvent.snapshot.value != null) {
        final fname = fnameEvent.snapshot.value.toString();

        // Retrieve lname from Firebase
        databaseRef.child('users').child(id).child('lname').onValue.listen((lnameEvent) {
          if (lnameEvent.snapshot.value != null) {
            final lname = lnameEvent.snapshot.value.toString();
            _name = '$fname $lname'; // Update fullName
            setState(() {
              _nameController.text = _name;
            });
          }
        });
      }
    });
    // Retrieve username from Firebase
    databaseRef.child('users').child(id).child('username2').onValue.listen((usernameEvent) {
      if (usernameEvent.snapshot.value != null) {
        final username = usernameEvent.snapshot.value.toString();
        setState(() {
          _username = username;
        });

      }
    });

    // Retrieve height and weight from Firebase
    databaseRef.child('users').child(id).child('height').onValue.listen((heightEvent) {
      if (heightEvent.snapshot.value != null) {
        final height = heightEvent.snapshot.value.toString();
        // Set _heightController.text
        setState(() {
          _heightController.text = height;
        });
      }
    });


    databaseRef.child('users').child(id).child('weight').onValue.listen((weightEvent) {
      if (weightEvent.snapshot.value != null) {
        final weight = weightEvent.snapshot.value.toString();
        // Set _weightController.text
        setState(() {
          _weightController.text = weight;
        });
      }
    });


    // Initialize text controllers with current values
    _nameController.text = _name;
    _emailController.text = user.email!;
    _passwordController.text = _password;
    _birthdayController.text = _birthday;
    _heightController.text = _height.toStringAsFixed(2); // Format height to two decimal places
    _weightController.text = _weight.toStringAsFixed(2); // Format weight to two decimal places
  }

  // Function to handle the profile picture selection from the gallery
  Future<void> selectProfilePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileName = pickedFile.path; // Get the path directly from pickedFile

      try {
        final task = await _storage.ref('profile pictures/$fileName').putFile(File(fileName));
        final downloadUrl = await task.ref.getDownloadURL();

        // Update the user's profile picture URL in the Realtime Database
        final databaseRef = FirebaseDatabase.instance.reference();
        final uid = widget.user.uid;

        databaseRef.child('users').child(uid).update({'profile_picture': downloadUrl});
      } catch (error) {
        final errorMessage = 'Error: $error';
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 30),
          ),
        );
        // Handle any errors that occur during the upload process

      }
    }
  }
 //getter
  String _userProfilePictureUrl() {
    try {
      final profilePicture = widget.user?.photoURL;

      if (profilePicture != null && profilePicture.isNotEmpty) {
        return profilePicture;
      } else {
        // Return a default image asset or placeholder URL if the user has no profile picture
        return 'assets/profile_picture.png'; // Update with your default image
      }
    } catch (e) {
      final errorMessage = 'Error fetching profile picture: $e';
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 30),
        ),
      );
      return 'assets/profile_picture.png'; // Update with your default image
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _onSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show user image, username, and select profile picture icon centered at the top
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_userProfilePictureUrl()),
                        radius: 75, // Adjust the radius as needed
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt, // Change to your desired icon
                            color: Colors.blue, // Change to your desired icon color
                          ),
                          onPressed: selectProfilePicture,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                      '@'+'$_username',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _buildTextFormField(
              label: 'Name',
              controller: _nameController,
            ),
            SizedBox(height: 16),
            _buildTextFormField(
              label: 'Email',
              controller: _emailController,
            ),
            SizedBox(height: 16),
            _buildPasswordFormField(),
            SizedBox(height: 16),
            _buildTextFormField(
              label: 'Birthday',
              controller: _birthdayController,
            ),
            SizedBox(height: 16),
            _buildTextFormField(
              label: 'Height (cm)',
              controller: _heightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            _buildTextFormField(
              label: 'Weight (kg)',
              controller: _weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            _buildForgotPasswordButton(),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    String? label,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding as needed
      ),
    );
  }

  TextFormField _buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      enabled: _isEditing,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding as needed
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  InkWell _buildForgotPasswordButton() {
    return InkWell(
      onTap: () {
        // Implement forgot password functionality here
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _onSave() {
    final databaseRef = FirebaseDatabase.instance.reference();
    final uid = widget.user.uid;

    // Check if editing mode is enabled
    if (_isEditing) {
      // Save changes when done editing
      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'birthday': _birthdayController.text,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'profile_picture': '', // Initialize to empty string
      };

      // Update the user's data in the Realtime Database
      databaseRef.child('users').child(uid).update(userData);

      // If a new profile picture was selected, update the profile picture URL
      if (widget.user.photoURL != null) {
        userData['profile_picture'] = widget.user.photoURL!;
        databaseRef.child('users').child(uid).update(
            {'profile_picture': widget.user.photoURL!});
      }
    }

    // Toggle editing mode
    setState(() {
      _isEditing = !_isEditing;
    });
  }}

