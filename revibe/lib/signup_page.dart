import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart'; 
import 'dart:async'; 
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'login_page.dart'; 

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

  String hashPassword(String password) {
    // SHA-256 for hashing
    var bytes = utf8.encode(password);
    var hashedPassword = sha256.convert(bytes).toString();
    return hashedPassword;
  }



class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = ''; // Variable to hold error messages


  bool isValidEmail(String email) {
  // Using regex for basic email validation
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

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
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // form submission logic here
                String firstName = firstNameController.text;
                String emailAddress = emailAddressController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                // Validate the input if needed
                // Print values to console
                // print('First Name: $firstName');
                print('test: $confirmPassword $password');

                // Validate the input
                if (firstName.isEmpty || emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                  // Display an error message
                  setState(() {
                    errorMessage = 'All fields are required';
                  });
                  return;
                }

                if (!isValidEmail(emailAddress)) {
                  // Display an error message
                  setState(() {
                    errorMessage = 'Invalid email address';
                  });
                  return;
                }

                if (password != confirmPassword) {
                  // Display an error message
                  setState(() {
                    errorMessage = 'Passwords do not match';
                  });
                  return;
                }

                // Hash the password
                String hashedPassword = hashPassword(password);
                // Perform further actions, for example, send data to Firebase
                await _submitToFirebase(context, firstName, emailAddress, hashedPassword);

              },
              child: const Text('Submit'),
            ),

            // Log In button to redirect to a different page
            TextButton(
              onPressed: () {
                // Navigate to the login page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Assuming LoginPage is your login page
                );
              },
              child: Text('Already a member? Log In'),
            ),

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
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
    final collection = FirebaseFirestore.instance.collection('users');
    try {
      await collection.doc().set(
        {
          'timestamp': FieldValue.serverTimestamp(),
          'firstname': firstName,
          'email': emailAddress,
          'password': password,

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
      // Display an error message on the page
      setState(() {
        errorMessage = 'Error submitting to Firebase: $error';
      });
      
    }

  }
}
