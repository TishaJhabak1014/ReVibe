import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async'; 
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'login_page.dart'; 

class FundraiserSignUp extends StatefulWidget {
  @override
  _FundraiserSignUpState createState() => _FundraiserSignUpState();
}

String hashPassword(String password) {
  // SHA-256 for hashing
  var bytes = utf8.encode(password);
  var hashedPassword = sha256.convert(bytes).toString();
  return hashedPassword;
}

class _FundraiserSignUpState extends State<FundraiserSignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _organizationNameController = TextEditingController();
  TextEditingController _causeController = TextEditingController();

  String errorMessage = '';

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fundraiser Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: "POC's Full Name"),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _organizationNameController,
                decoration: InputDecoration(labelText: 'Organization Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _causeController,
                decoration: InputDecoration(labelText: 'Cause'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      setState(() {
                        errorMessage = 'Passwords do not match';
                      });
                      return;
                    }

                   if (_formKey.currentState?.validate() ?? false) {
                      // Form is valid, proceed with the submission
                      // Access the values using controller.text
                      String pocName = _firstNameController.text;
                      String org = _organizationNameController.text;
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      String cause = _causeController.text;
                      
                      password = hashPassword(password);
                      
                      await _submitFundraiserToFirebase(context, pocName, org, email, password, cause);

                    }

                },
                child: Text('Sign Up'),
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
      ),
    );
  }


  Future<void> _submitFundraiserToFirebase(
      BuildContext context, String pocName, String org, String email, String password, String cause) async {
    // Your Firebase logic for business sign-up here
    // Note: Ensure you have initialized Firebase in your app before using these services
    // Example:
    final collection = FirebaseFirestore.instance.collection('fundraisers');
    try {
      await collection.doc().set(
        {
          'timestamp': FieldValue.serverTimestamp(),
          'pocName': pocName,
          'organisationName': org,
          'email': email,
          'password': password,
          'cause': cause
          // ... (similarly for other fields)
        },
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(userType: 3),
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
