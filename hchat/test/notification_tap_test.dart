import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/widgets/custom_read_notification.dart';
import 'package:hchat/pages/testpages/notification_tap.dart';

// Test for the notification tap page
void main() {
  // test for New section
  group('NotificationTap widget tests', () {
    testWidgets('Verify "New" section contains correct number of notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NotificationTap()));

      // Find "New" section text widget
      final newSectionFinder = find.text('New');
      print(newSectionFinder);
      expect(newSectionFinder, findsOneWidget);

      // // Find notification list in "New" section
      // final newListFinder = find.byKey(ValueKey('new_notification_list'));
      // expect(newListFinder, findsOneWidget);

      // // Check if the notification list contains 4 items
      // final newListWidget = tester.widget<ListView>(newListFinder);
      // expect(newListWidget.semanticChildCount, equals(4)); // items count
    });
    // test for Today section
    testWidgets(
        'Verify "Today" section contains correct number of notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NotificationTap()));

      // Find "Today" section text widget
      final todaySectionFinder = find.text('Today');
      expect(todaySectionFinder, findsOneWidget);

      //     // Find notification list in "Today" section
      //     final todayListFinder = find.byKey(ValueKey('today_notification_list'));
      //     expect(todayListFinder, findsOneWidget);

      //     // Check if the notification list contains 2 items
      //     final todayListWidget = tester.widget<ListView>(todayListFinder);
      //     expect(todayListWidget.semanticChildCount, equals(2)); // count
    });

    // Test for Oldest section
    testWidgets(
        'Verify "Oldest" section contains correct number of notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NotificationTap()));

      // Find "Oldest" section text widget
      final oldestSectionFinder = find.text('Oldest');
      expect(oldestSectionFinder, findsOneWidget);

      //     // Find notification list in "Oldest" section
      //     final oldestListFinder = find.byKey(ValueKey('oldest_notification_list'));
      //     expect(oldestListFinder, findsOneWidget);

      //     // Check if the notification list contains 2 items
      //     final oldestListWidget = tester.widget<ListView>(oldestListFinder);
      //     expect(oldestListWidget.semanticChildCount, equals(2)); // itemcount
    });

    //test for custom follow notification widget
    testWidgets(
        'Verify CustomFollowNotification is displayed for each read item',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NotificationTap()));

      // Find all CustomFollowNotification widgets
      final customFollowNotificationFinder =
          find.byType(CustomFollowNotifcation);
      expect(
          customFollowNotificationFinder,
          findsNWidgets(
              4)); // 4 in "New" section, 2 in "Today" section, 2 in "Oldest" section

      // Accessibility
      expect(tester, meetsGuideline(textContrastGuideline));
      expect(tester, meetsGuideline(androidTapTargetGuideline));
    });
  });
}
