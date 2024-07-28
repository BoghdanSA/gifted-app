import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gifted_app/main.dart';
import 'package:gifted_app/screens/login_page.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GiftedApp());

    // Verify that the app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget, reason: 'MaterialApp not found');

    // Verify that the LoginPage is the first screen
    expect(find.byType(LoginPage), findsOneWidget, reason: 'LoginPage not found');

    // Verify that there's at least one text form field (for email or password)
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1), reason: 'No TextFormField found');

    // Verify that there's a button (it might be for login or sign up)
    expect(find.byType(ElevatedButton), findsOneWidget, reason: 'No ElevatedButton found');

    // Print the widget tree for debugging
    debugPrint(tester.binding.rootElement?.toStringDeep());
  });
}