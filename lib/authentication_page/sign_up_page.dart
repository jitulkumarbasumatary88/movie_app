import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/authentication_page/sign_in_page.dart';
import '../home_page/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      // manually color
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // full name
                TextField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    // manually color
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // email
                TextField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    // manually color
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    // manually color
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // confirm password
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    // manually color
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // create
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () async {
                      // password check
                      if (passwordController.text.trim() !=
                          confirmController.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match')),
                        );
                        return;
                      }
                      try {
                        // firebase sign up
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                        // 🔥 GET UID OF NEW USER
                        String uid = FirebaseAuth.instance.currentUser!.uid;

                        // 🔥 CREATE FIRESTORE PROFILE DOCUMENT
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .set({
                              "name": nameController.text.trim(),
                              "email": emailController.text.trim(),
                              "phone": "",
                              "bio": "",
                            });

                        // homepage
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                          (route) => false,
                        );
                      } catch (e) {
                        print('Sign Up Error : $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                'Sign up failed. Please check your details.',
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // already account? sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      // manually color
                      style: TextStyle(color: Colors.black),

                      // manually color
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
