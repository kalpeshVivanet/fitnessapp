import 'package:demoapp/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/home.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  
  const HomeScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Welcome illustration
              Stack(
                alignment: Alignment.center,
                children: [
                                
                  // Fitness couple illustration
                  Image.asset(
                    'assets/images/Group.png',
                    height: 240,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Welcome text
              Text(
                'Welcome, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Subtitle text
              const Text(
                'You are all set now, let\'s reach your goals together with us',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Go To Home button
              ElevatedButton(
                onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D6BFF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Go To Home',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
