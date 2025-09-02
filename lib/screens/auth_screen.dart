// screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Ensure correct path here

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Corrected to AuthService
  bool _isLogin = true; // Track whether it's login or signup

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple, // Header color
      ),
      body: Container(
        decoration: BoxDecoration( // Background Decoration
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.purple[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent, // Button color
                  foregroundColor: Colors.white, // Button text color
                ),
                onPressed: () async {
                  try {
                    if (_isLogin) {
                      await _authService.signIn(_emailController.text, _passwordController.text);
                      Navigator.pop(context); // Go back to previous screen
                    } else {
                      await _authService.signUp(_emailController.text, _passwordController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign up successful. Please check your email to verify your account.')));
                      setState(() => _isLogin = true); // Switch to login after signup
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication failed: $e')));
                  }
                },
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple, // TextButton color
                ),
                onPressed: () {
                  setState(() => _isLogin = !_isLogin); // Toggle between login and signup
                },
                child: Text(_isLogin ? 'Don\'t have an account? Sign up' : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}