
import 'package:flutter/material.dart';

class profilexs extends StatelessWidget {
  const profilexs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
