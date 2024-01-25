import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Function to hash the password using SHA-256
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var hashedPassword = sha256.convert(bytes).toString();
  return hashedPassword;
}

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Log In button
            ElevatedButton(
              onPressed: () {
                // Add logic for handling login
                String email = emailController.text;
                String password = passwordController.text;

                // Perform further actions, e.g., check in the database
                _performLogin(context, email, password);
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }

 
  void _performLogin(BuildContext context, String email, String password) async {
    try {
      String hashedPassword = hashPassword(password);

      print(hashedPassword);

      final collection = FirebaseFirestore.instance.collection('users');
      var querySnapshot = await collection.where('email', isEqualTo: email).where('password', isEqualTo: hashedPassword).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Matching record found, perform login actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login successful'),
            backgroundColor: Colors.red,
          ),
        );
        // print('Login successful');

        // Redirect to the dashboard page
      // Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
      //   'username': querySnapshot.docs.first['username'], 
      // });

      Navigator.pushNamed(
        context,
        '/dashboard',
        arguments: {'userName': querySnapshot.docs.first['firstname'],
        }, 
      );

      } else {
        // No matching record found, show an error message
        // print('Login failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Handle database errors
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    
  }
  }
}