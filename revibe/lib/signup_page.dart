import 'package:flutter/material.dart';

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
              onPressed: () {
                // form submission logic here
                String firstName = firstNameController.text;
                String emailAddress = emailAddressController.text;
                String password = passwordController.text;

                // Validate the input if needed
                // Print values to console
                print('First Name: $firstName');
                print('Email Address: $emailAddress');


                // Perform further actions, for example, send data to Firebase
                _submitToFirebase(firstName, emailAddress, password);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  // Example function to submit data to Firebase
  void _submitToFirebase(String firstName, String emailAddress, String password) {
    // Your Firebase logic here, e.g., using Firebase Realtime Database or Firestore
    // Note: Ensure you have initialized Firebase in your app before using these services
    // Example:
    // FirebaseDatabase.instance.reference().child("users").push().set({
    //   "firstName": firstName,
    //   "emailAddress": emailAddress,
    //   "password": password,
    // });

    // You can also navigate to another page after successful submission
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SuccessPage(),
    //   ),
    // );
  }
}
