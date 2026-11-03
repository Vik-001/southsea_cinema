import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders its label and taps correctly', (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'TEST BUTTON',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    // Verify it shows the text
    expect(find.text('TEST BUTTON'), findsOneWidget);

    // Verify it clicks successfully
    await tester.tap(find.text('TEST BUTTON'));
    await tester.pump();
    expect(wasPressed, isTrue);
  });
}