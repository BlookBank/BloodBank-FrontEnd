import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloodbank/main.dart';

void main() {
  testWidgets('App starts on the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);

    // Deja terminar el timer del splash para que no queden timers pendientes.
    await tester.pump(const Duration(seconds: 3));
  });
}
