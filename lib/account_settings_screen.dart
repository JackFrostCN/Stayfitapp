
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomeScreen.dart';


class AccountSettingsScreen extends StatefulWidget {

  final User user;



  AccountSettingsScreen({required this.user});
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState(user: user);
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final User user;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String imgurl = '';

  _AccountSettingsScreenState({required this.user});

  String _name = '';
  String _email = '';
  String _birthday = '';
  double _height = 0; // Initial height in centimeters
  double _weight = 0; // Initial weight in kilograms
  String _username = '';


  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
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
    databaseRef
        .child('users')
        .child(id)
        .child('fname')
        .onValue
        .listen((fnameEvent) {
      if (fnameEvent.snapshot.value != null) {
        final fname = fnameEvent.snapshot.value.toString();

        // Retrieve lname from Firebase
        databaseRef
            .child('users')
            .child(id)
            .child('lname')
            .onValue
            .listen((lnameEvent) {
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


    // Retrieve height and weight from Firebase
    databaseRef
        .child('users')
        .child(id)
        .child('height')
        .onValue
        .listen((heightEvent) {
      if (heightEvent.snapshot.value != null) {
        final height = heightEvent.snapshot.value.toString();
        // Set _heightController.text
        setState(() {
          _heightController.text = height;
        });
      }
    });


    databaseRef
        .child('users')
        .child(id)
        .child('weight')
        .onValue
        .listen((weightEvent) {
      if (weightEvent.snapshot.value != null) {
        final weight = weightEvent.snapshot.value.toString();
        // Set _weightController.text
        setState(() {
          _weightController.text = weight;
        });
      }
    });
    // Retrieve username2 from Firebase
    databaseRef
        .child('users')
        .child(widget.user.uid)
        .child('username2')
        .onValue
        .listen((usernameEvent) {
      if (usernameEvent.snapshot.value != null) {
        _username = usernameEvent.snapshot.value.toString();
        setState(() {
          _usernameController.text = usernameEvent.snapshot.value.toString();
        });
      }
    });
    // Retrieve birthday from Firebase
    databaseRef
        .child('users')
        .child(widget.user.uid)
        .child('birthday')
        .onValue
        .listen((birthdayEvent) {
      if (birthdayEvent.snapshot.value != null) {
        _birthday = birthdayEvent.snapshot.value.toString();
        setState(() {
          _birthdayController.text = birthdayEvent.snapshot.value.toString();
        });
      }
    });
    // Retrieve imgurl from Firebase
    databaseRef
        .child('users')
        .child(widget.user.uid)
        .child('profile_picture')
        .onValue
        .listen((propicEvent) {
      if (propicEvent.snapshot.value != null) {
        setState(() {
          imgurl = propicEvent.snapshot.value.toString();
        });
      }
    });


    // Initialize text controllers with current values
    _nameController.text = _name;
    _emailController.text = user.email!;
    _usernameController.text = _username;
    _birthdayController.text = _birthday;
    _heightController.text =
        _height.toStringAsFixed(2); // Format height to two decimal places
    _weightController.text =
        _weight.toStringAsFixed(2); // Format weight to two decimal places
  }

  // Function to handle the profile picture selection from the gallery
  Future<void> selectProfilePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileName = pickedFile.path; // Get the path directly from pickedFile

      try {
        final task = await _storage.ref('profile pictures/$fileName').putFile(
            File(fileName));
        final downloadUrl = await task.ref.getDownloadURL();

        // Update the user's profile picture URL in the Realtime Database
        final databaseRef = FirebaseDatabase.instance.reference();
        final uid = widget.user.uid;

        databaseRef.child('users').child(uid).update(
            {'profile_picture': downloadUrl});
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back), // You can use any icon you want
            color: Colors.blueAccent, // Change the color to your desired color
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => HomeScreen2(user: user)),
              );
            }),
        // ...
        title: Text('Account Setting',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black, // Set the text color to black
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _onSave,
            color: Colors.black,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
        toolbarHeight: 80.0,
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
                        backgroundImage: NetworkImage(imgurl),
                        radius: 80,
                        child: imgurl == null || imgurl.isEmpty
                            ? Image.asset('assets/profile_picture.png')
                            : null,
                      ),
                      Positioned(
                        bottom: 5, // Adjust the bottom position as needed
                        right: 5, // Adjust the right position as needed
                        child: Container(
                          width: 40,
                          // Adjust the width of the circular background
                          height: 40,
                          // Adjust the height of the circular background
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .blue, // Change to your desired background color
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors
                                  .white, // Change to your desired icon color
                            ),
                            onPressed: selectProfilePicture,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '@' + '$_username',
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
            _buildTextFormField(
              label: 'Username',
              controller: _usernameController,
            ),
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
          borderRadius: BorderRadius.circular(
              12.0), // Adjust the border radius as needed
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), // Adjust padding as needed
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


  Future<void> _onSave() async {
    final databaseRef = FirebaseDatabase.instance.reference();
    final uid = widget.user.uid;
    String fullName = _nameController.text;
    List<String> nameParts = fullName.split(' ');

    String firstName = nameParts[0];
    String lastName = nameParts.length > 1 ? nameParts[1] : '';


    // Check if editing mode is enabled
    if (_isEditing) {

      // Save changes when done editing
      final userData = {
        'name': _nameController.text,
        'fname': firstName,
        'lname': lastName,
        'email': _emailController.text,
        'username2': _usernameController.text,
        'birthday': _birthdayController.text,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),

      };

      // Update the user's data in the Realtime Database
      databaseRef.child('users').child(uid).update(userData);

      // If a new profile picture was selected, update the profile picture URL
      if (widget.user.photoURL != null) {
        userData['profile_picture'] = widget.user.photoURL!;
        databaseRef.child('users').child(uid).update(
            {'profile_picture': widget.user.photoURL!});
      }
      databaseRef.child('users').child(uid).update(userData);
    }
    // Change the user's email address !! DONT TOUCH !!
    /*try {
      await widget.user.updateEmail(_emailController.text);
      print('Email address updated to ${_emailController.text}');
    } catch (e) {
      print('Error updating email: $e');
    }*/


    // Toggle editing mode
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1), // Initial date
      firstDate: DateTime(1900, 1, 1), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date
    );

    if (selectedDate != null) {
      setState(() {
        _birthdayController.text = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      });
    }
    if (_isEditing){GestureDetector(
      onTap: _isEditing ? () => _selectDate(context) : null,
      child: _buildTextFormField(
        label: 'Birthday',
        controller: _birthdayController,
      ),
    );

    }


}}
