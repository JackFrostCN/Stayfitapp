import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';



class MyApp extends StatelessWidget {
  final User user;
  MyApp({required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataSafetyGuaranteeScreen(user: user),

    );

  }
}

class DataSafetyGuaranteeScreen extends StatelessWidget {
  final User user;

  DataSafetyGuaranteeScreen({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // You can use any icon you want
          color: Colors.blueAccent, // Change the color to your desired color
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen2(user: user)),
            );
          },
        ),
        title: Text('Data Safety Guarantee',style: TextStyle(
          fontSize: 25,
          color: Colors.black, // Set the text color to black
          fontWeight: FontWeight.bold, // Make the text bold
        ),),
        backgroundColor: Colors.white,
        elevation: .0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Text(
                'At StayFit, we care about your privacy and data security. Your trust is important to us, and we want to assure you that your personal information and health data are handled with the utmost care and respect. We are committed to providing you with a safe and secure environment for your fitness and nutrition journey.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Our Pledge to You:\n',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              DataSafetyFeature(

                icon: Icons.lock, // Encryption icon
                title: 'Strict Data Encryption',
                description:
                'Your data is encrypted both in transit and at rest. We use the latest security protocols to safeguard your information and ensure it remains confidential.',
              ),
              Padding(
                padding: EdgeInsets.all(10), // Add right padding here

              ),
              DataSafetyFeature(
                icon: Icons.playlist_add_check, // Minimal data collection icon
                title: 'Minimal Data Collection',
                description:
                'We only collect the information necessary to provide you with the best user experience. Your data is never used for anything other than improving your StayFit experience.',
              ),
              Padding(
                padding: EdgeInsets.all(10), // Add right padding here

              ),
              DataSafetyFeature(
                icon: Icons.privacy_tip, // Permission control icon
                title: 'Permission Control',
                description:
                'StayFit requests only the permissions required for the app\'s core functionality. You have full control over the data you choose to share.',
              ),
              Padding(
                padding: EdgeInsets.all(10), // Add right padding here

              ),
              DataSafetyFeature(
                icon: Icons.security, // Security audits icon
                title: 'Regular Security Audits',
                description:
                'We conduct routine security audits to identify and address potential vulnerabilities. Your data\'s safety is an ongoing commitment for us.',
              ),
              Padding(
                padding: EdgeInsets.all(10), // Add right padding here

              ),
              DataSafetyFeature(
                icon: Icons.visibility, // Transparency icon
                title: 'Transparency',
                description:
                'We are open about how your data is used and have a detailed Privacy Policy that explains our practices. We believe in transparent and honest communication.',
              ),

              SizedBox(height: 16),
              Text(
                'Your Data, Your Control\n',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'StayFit puts you in control of your data. You can update your privacy settings, manage permissions, and delete your account whenever you choose. We\'re here to assist you in making the most of your fitness and nutrition journey while respecting your privacy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Questions or Concerns?\n',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'If you have any questions, concerns, or feedback regarding data security and privacy, please don\'t hesitate to contact our support team. We\'re here to provide assistance and ensure your peace of mind.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for choosing StayFit. We look forward to helping you achieve your health and fitness goals while keeping your data safe and sound.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\nStay healthy, stay secure, and stay fit!\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Sincerely,\nThe StayFit Team',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataSafetyFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  DataSafetyFeature({
  required this.icon,
  required this.title,
  required this.description,
});

@override
Widget build(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 24),
      SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ],
  );
}
}
