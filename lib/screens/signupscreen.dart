
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/firebase_auth/auth_services.dart';
import 'package:finalproject/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';





class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          width: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color(0xFF515C6F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF727C8E)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF727C8E)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF727C8E)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {

                  _signUp();
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>const HomePge()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFFFF6969),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'By creating an account, you agree to our\n'
                ,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF515C6F),
                ),
                textAlign: TextAlign.center,
              ),
              const Text( 'Terms of Service and Privacy Policy',
                style:TextStyle(
                  fontSize:12,
                  color: Color(0xFFFF6969),

                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
  _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      var authCredential = userCredential.user;

      // Check if the UID already exists in the database
      bool isUidExists = await isUidAlreadyExists(authCredential!.uid);

      if (isUidExists) {
        Fluttertoast.showToast(msg: "Sorry, you can't sign up. Please sign in.");
      } else {
        // Additional user data to save in Firestore
        Map<String, dynamic> userData = {
          'uid': authCredential.uid,
          'email': emailController.text,
          'username':usernameController.text,
          // Add more fields as needed
        };

        // Save user data to Firestore
        await saveUserDataToFirestore(authCredential.uid, userData);

        // Continue with your sign-up logic
        print(authCredential.uid);
        Navigator.push(context, CupertinoPageRoute(builder: (_) => const HomePge()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

// Function to check if UID already exists in Firestore
  Future<bool> isUidAlreadyExists(String uid) async {
    try {
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDocument.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

// Function to save user data to Firestore
  Future<void> saveUserDataToFirestore(String uid, Map<String, dynamic> userData) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
    } catch (e) {
      print(e);
    }
  }


}