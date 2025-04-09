import 'package:demoapp/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
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
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : hint == "Phone number"
              ? TextInputType.phone
              : TextInputType.text,
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

  void registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'authId': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    "Create an account",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField(nameController, "Full Name", Icons.person),
                const SizedBox(height: 20),
                buildTextField(phoneController, "Phone number", Icons.phone),
                const SizedBox(height: 20),
                buildTextField(emailController, "Email", Icons.email,
                    isEmail: true),
                const SizedBox(height: 20),
                buildTextField(passwordController, "Password", Icons.lock,
                    isPassword: true),
                const SizedBox(height: 40),
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFFB388EB))
                      : ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(300, 50)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFB388EB)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: registerUser,
                          child: const Text(
                            "Register",
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text.rich(TextSpan(
                      text: "Already have an account?",
                      children: [
                        TextSpan(
                          text: " Log in",
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
