import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/add_recipient_page.dart';
import 'screens/recipient_list_page.dart';
import 'screens/gift_suggestion_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gifted App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add_recipient': (context) => const AddRecipientPage(),
        '/recipient_list': (context) => const RecipientListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/gift_suggestion') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return GiftSuggestionPage(
                recipientName: args['name']!,
                relationship: args['relationship']!,
              );
            },
          );
        }
        return null;
      },
    );
  }
}