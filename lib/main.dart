import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/add_recipient_page.dart';
import 'screens/recipient_list_page.dart';
import 'screens/gift_suggestion_page.dart';
import 'screens/edit_recipient_page.dart';
import 'screens/gift_ideas_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/home': (context) => HomePage(),
        '/add_recipient': (context) => const AddRecipientPage(),
        '/recipient_list': (context) => RecipientListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/gift_suggestion') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => GiftSuggestionPage(
              recipientName: args['name']!,
              relationship: args['relationship']!,
            ),
          );
        } else if (settings.name == '/edit_recipient') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => EditRecipientPage(
              recipientId: args['id'],
              recipientData: args['data'],
            ),
          );
        } else if (settings.name == '/gift_ideas') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => GiftIdeasPage(
              recipientId: args['id']!,
              recipientName: args['name']!,
            ),
          );
        }
        return null;
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}