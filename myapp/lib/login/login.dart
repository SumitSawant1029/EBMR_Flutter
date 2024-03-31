import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/login/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/uifiles/home.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 39, 181),
        title: Text(
          'Login',
          style: TextStyle(
            color: Color.fromARGB(255, 241, 241, 241),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 32.0),
            Image.asset(
              'assets/images/login_background.png',
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 350,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Container(
                      width: 350,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Color.fromARGB(255, 252, 252, 252),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Center(
                    child: Container(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: () async {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          User? user = await _authService
                            .signInWithEmailAndPassword(email, password);
                          
                          if (email=='sumit@gmail.com' && password=="sumit@1029"){
                                Navigator.pushReplacementNamed(
                              context,
                              '/admin',
                              arguments:email,
                            );
                          }
                          else if (user != null) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/home',
                              arguments:email,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Login failed. Please try again.',
                                backgroundColor: Colors.white);
                          }
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 79, 39, 181),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      'Create an Account',
                      style: TextStyle(color: Color.fromARGB(255, 79, 39, 181)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
