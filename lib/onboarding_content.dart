import 'dart:ffi';

import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const OnboardingContent({super.key, required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Image.asset(
          image,
          width: 375,
        ),
        SizedBox(height:40,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title,
          style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,),
          SizedBox(height: 20,),
           Text(description,
          style: TextStyle(fontSize: 16,color: Colors.grey),
          textAlign: TextAlign.center,)
            ],
          ),
        )
        
      ],
    );
  }
}