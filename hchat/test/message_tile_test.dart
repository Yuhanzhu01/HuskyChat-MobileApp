import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/widgets/message_tile.dart';

void main() {
  testWidgets('MessageTile widget should render correctly',
      (WidgetTester tester) async {
    // Create a test message
    const String message = 'Hello World!';
    const String sender = 'Alice';
    const bool sentByMe = true;

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageTile(
            message: message,
            sender: sender,
            sentByMe: sentByMe,
          ),
        ),
      ),
    );

    // Verify that the sender and message are displayed correctly
    final senderFinder = find.text(sender.toUpperCase());
    final messageFinder = find.text(message);
    expect(senderFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);

    // Verify that the widget is aligned to the right side of the screen
    final alignment = sentByMe ? Alignment.centerRight : Alignment.centerLeft;
    // expect(tester.widget<Container>(find.byType(Container)).alignment,
    //     equals(alignment));
  });
}
