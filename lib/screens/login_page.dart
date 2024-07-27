import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool isLogin = true;

  void _toggleView() {
    setState(() {
      isLogin = !isLogin;
      error = '';
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = isLogin
          ? await _auth.signIn(email, password)
          : await _auth.signUp(email, password);
      if (mounted) {  // Check if the widget is still in the tree
        if (result == null) {
          setState(() => error = 'Please supply a valid email and password');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login to Gifted App' : 'Sign Up for Gifted App'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) => setState(() => email = val),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) => setState(() => password = val),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Sign In' : 'Sign Up'),

              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              TextButton(
                onPressed: _toggleView,
                child: Text(isLogin ? 'Need an account? Sign Up' : 'Have an account? Sign In'),

              ),
            ],
          ),
        ),
      ),
    );
  }
}