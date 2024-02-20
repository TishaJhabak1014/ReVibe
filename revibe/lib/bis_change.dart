import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; 
import 'dart:async'; 
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'login_page.dart'; 


class BisChange extends StatefulWidget {
  final String businessId;
  String password ="hello";

  BisChange({required this.businessId});
  @override
  _BisChangeState createState() => _BisChangeState();
}

String hashPassword(String password) {
  // SHA-256 for hashing
  var bytes = utf8.encode(password);
  var hashedPassword = sha256.convert(bytes).toString();
  return hashedPassword;
}


class _BisChangeState extends State<BisChange> {
  
  final _formKey = GlobalKey<FormState>();

  TextEditingController businessNameController = TextEditingController();
  TextEditingController abnController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('businesses').doc(widget.businessId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          print(widget.businessId);
          print(snapshot.hasData);
          print(snapshot.data!.exists);
          return Text('Document does not exist.cccc');
        } else {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          String email = data['email'];
          emailAddressController.text = email;
          String firstName = data['firstName'];
          businessNameController.text = firstName;
          String password = data['password'];
          widget.password = password;
          String abn = data['abn'];
          abnController.text = abn;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const Text(
                    'ReVibe',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color.fromRGBO(221, 242, 232, 1),
            ),
            
            
            body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
              color: const Color(0xFFF0F3EF),
              child:
                Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      'Change Profile Information',
                      style: GoogleFonts.workSans(
                        textStyle: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF107208),
                          height: 1, 
                        ),
                      ),
                    ),




                    const SizedBox(height: 75.0),
                    TextFormField(
                      controller: businessNameController,
                      decoration: InputDecoration(labelText: 'Business Name'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: abnController,
                      decoration: InputDecoration(labelText: 'ABN'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    
                    TextFormField(
                      controller: emailAddressController,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),

                    //  Contact details
                    
                    // Replace TextField with TextFormField for the rest of the fields
                    // ...
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,

                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,

                    ),
                    SizedBox(height: 50),
                    
                    ElevatedButton(
                      onPressed: () async {

                        if (passwordController.text != confirmPasswordController.text) {
                            setState(() {
                            errorMessage = 'Passwords do not match';
                          });
                          return;
                        }

                        if (_formKey.currentState?.validate() ?? false) {
                          String businessName = businessNameController.text;
                          String abn = abnController.text;
                          String email = emailAddressController.text;
                          String password = passwordController.text;
                          if (passwordController.text.isEmpty && confirmPasswordController.text.isEmpty){
                            password = widget.password;
                          }
                          else{
                            password = passwordController.text;
                            password = hashPassword(password);
                          }


                          await _submitBusinessToFirebase(context, businessName, abn, email, password);
                        }
                      },

                      style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const Color(0xFF107208); 
                        }
                        return Colors.white;
                      }),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.white; 
                        }
                        return Colors.black;
                      }),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
                      ),

                      child: const Text('Submit Business Sign Up'),






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
            ),
          );
        }
      }
    );
  }

  // ... (submit function)
  // Example function to submit business data to Firebase
  Future<void> _submitBusinessToFirebase(
      BuildContext context, String businessName, String abn, String email, String password) async {
    // Your Firebase logic for business sign-up here
    // Note: Ensure you have initialized Firebase in your app before using these services
    // Example:
    final collection = FirebaseFirestore.instance.collection('businesses');
    try {
      await collection.doc(widget.businessId).set(
        {
          'timestamp': FieldValue.serverTimestamp(),
          'firstName': businessName,
          'abn': abn,
          'email': email,
          'password': password
          // ... (similarly for other fields)
        },
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(userType: 2),
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


  