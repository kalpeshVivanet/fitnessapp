import 'package:demoapp/onboarding_content.dart';
import 'package:demoapp/signup.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Track Your Goal',
      'description': "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Get Burn',
      'description': 'Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Eat Well',
      'description': "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
    },
     {
      'image': 'assets/images/onboarding4.png',
      'title': 'Improve Sleep  Quality',
      'description': 'Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          OnboardingContent(
            image: onboardingData[currentIndex]['image']!,
            title: onboardingData[currentIndex]['title']!,
            description: onboardingData[currentIndex]['description']!,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          if (currentIndex < onboardingData.length - 1) {
            setState(() {
              currentIndex++;
            });
          } else {
            // Navigator.pushReplacementNamed(context, '/home');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUp()));
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
