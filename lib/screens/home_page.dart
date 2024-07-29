import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gifted App Home'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Gifted App! You are logged in.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_recipient');
              },
              child: const Text('Add Gift Recipient'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recipient_list');
              },
              child: const Text('View Recipients'),
            ),
          ],
        ),
      ),
    );
  }
}