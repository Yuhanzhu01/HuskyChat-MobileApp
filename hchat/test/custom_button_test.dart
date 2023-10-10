import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/helper/colors.dart';
import 'package:hchat/widgets/custom_button.dart';

void main() {
  // test custom button for notification page
  group('CustomButton', () {
    const buttonText = 'Button';
    final buttonFinder = find.widgetWithText(CustomButton, buttonText);
    final mockOnTap = () => print('Button tapped!');



    // test the ontap function for the button
    testWidgets('button calls onTap function when tapped',
        (WidgetTester tester) async {
      var tapped = false;
      final mockOnTap = () => tapped = true;


      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomButton(text: buttonText, onTap: mockOnTap),
        ),
      ));

      await tester.tap(buttonFinder);
      expect(tapped, isTrue);
    });



    //test renders button with test
    testWidgets('renders button with text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomButton(text: buttonText, onTap: mockOnTap),
        ),
      ));

      expect(buttonFinder, findsOneWidget);
      
    // Accessibility
    expect(tester, meetsGuideline(textContrastGuideline));
    expect(tester, meetsGuideline(androidTapTargetGuideline));
    });


 
    
  });
  

}






