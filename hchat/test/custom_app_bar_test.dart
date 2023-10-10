import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/widgets/custom_app_bar.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('renders a white AppBar with a logo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const CustomAppBar(),
          ),
        ),
      );

      // Find the AppBar widget
      final appBarFinder = find.byType(AppBar);

      // Ensure that the AppBar is present and has a white background color
      expect(appBarFinder, findsOneWidget);
      final appBarWidget = tester.widget(appBarFinder) as AppBar;
      expect(appBarWidget.backgroundColor, equals(Colors.white));

      // Find the Husky logo widget
      final huskyLogoFinder = find.byType(Image);

      // Ensure that the Husky logo is present and has a height of 60
      expect(huskyLogoFinder, findsOneWidget);
      final huskyLogoWidget = tester.widget(huskyLogoFinder) as Image;
      // expect(huskyLogoWidget.image, equals('assets/huskypng.png'));
      expect(huskyLogoWidget.height, equals(60));
    });
  });
}
