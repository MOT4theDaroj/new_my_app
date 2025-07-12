import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Container(
        color: Colors.amber,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Container(color: Colors.blue),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Container(color: Colors.red),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Container(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
