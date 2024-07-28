import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/add_recipient_page.dart';
import 'screens/recipient_list_page.dart';
import 'screens/gift_suggestion_page.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
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
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
          );
        }

        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}