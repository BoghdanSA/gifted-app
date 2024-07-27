// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gifted_app/main.dart';
import 'package:gifted_app/screens/login_page.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GiftedApp());

    // Verify that the app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that the LoginPage is the first screen
    expect(find.byType(LoginPage), findsOneWidget);

    // Verify that the login page has the expected title
    expect(find.text('Login to Gifted App'), findsOneWidget);

    // Verify that there are two text form fields (email and password)
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify that there's a login button
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });
}
