import 'package:flutter/material.dart';

Widget buildHeader(String text) {
  return SizedBox(
    width: double.infinity,
    child: Stack(
      children: [
        Image.asset("assets/Frame 18341.png", fit: BoxFit.cover),
        Positioned(
          top: 60,
          left: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.dashboard, color: Colors.black, size: 24),
              onPressed: () {},
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.black, size: 24),
              onPressed: () {},
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}
