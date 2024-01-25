import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart'; // Import the SignUpPage widget
import 'dart:async'; 

class SignUpPage extends StatelessWidget {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailAddressController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // form submission logic here
                String firstName = firstNameController.text;
                String emailAddress = emailAddressController.text;
                String password = passwordController.text;

                // Validate the input if needed
                // Print values to console
                print('First Name: $firstName');
                print('Email Address: $emailAddress');

                // Perform further actions, for example, send data to Firebase
                await _submitToFirebase(context, firstName, emailAddress, password);

              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  // Example function to submit data to Firebase
  Future<void> _submitToFirebase(
      BuildContext context, String firstName, String emailAddress, String password) async {
    // Your Firebase logic here, e.g., using Firebase Realtime Database or Firestore
    // Note: Ensure you have initialized Firebase in your app before using these services
    // Example:
    final collection = FirebaseFirestore.instance.collection('signup');
    try {
      await collection.doc().set(
        {
          'timestamp': FieldValue.serverTimestamp(),
          'firstName': firstName,
        },
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    } catch (error) {
      print('Error submitting to Firebase: $error');
      // Handle the error appropriately, e.g., show an error message to the user
    }

  }
}
