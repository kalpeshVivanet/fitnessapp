
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/home.dart';
import 'package:demoapp/signup.dart'; // Changed from login.dart to signup.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  buildTextField(TextEditingController controller, String hint, IconData icon,
      {bool isEmail = false, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
      ),
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        }
        if (isEmail &&
            !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  void loginUser() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  
  setState(() {
    _isLoading = true;
  });
  
  try {
    // Login with Firebase Auth
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    
    // Get user data from Firestore using the authId
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .get();
    
    if (userDoc.exists) {
      // Extract the user's name from the Firestore document
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userName = userData['name'] ?? 'User';
      
      // Navigate to welcome screen with the user's name
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen(userName: userName))
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    "Hey there",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField(emailController, "Email", Icons.email, isEmail: true),
                const SizedBox(height: 20),
                buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () async{
                     await _auth.sendPasswordResetEmail(email: emailController.text.trim());
                    }, 
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(color: Color(0xFFB388EB)),
                    )
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Color(0xFFB388EB))
                      : ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                            backgroundColor: MaterialStateProperty.all(const Color(0xFFB388EB)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: loginUser,
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                ),
                const SizedBox(height: 30),
                const Center(child: Text("or")),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.g_mobiledata, size: 40),
                    SizedBox(width: 20),
                    Icon(Icons.facebook, size: 40)
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                    child: const Text.rich(TextSpan(
                      text: "Don't have an account?",
                      children: [
                        TextSpan(
                          text: " Sign up",
                          style: TextStyle(color: Color(0xFFB388EB)),
                        ),
                      ],
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}