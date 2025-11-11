import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final AuthService _auth = AuthService();
  bool _showSignIn = true;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (!_isValidEmail(email)) {
      _showSnackBar('Please enter a valid email like test@gsu.com');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    try {
      if (_showSignIn) {
        await _auth.signInWithEmailAndPassword(email, password);
      } else {
        await _auth.registerWithEmailAndPassword(email, password);
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showSignIn ? 'Sign In' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_showSignIn ? 'Sign In' : 'Register'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _toggleView,
              child: Text(
                _showSignIn 
                  ? 'Need an account? Register here'
                  : 'Already have an account? Sign in here',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}