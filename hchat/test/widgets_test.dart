import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/widgets/widgets.dart';

void main() {
  test('textInputDecoration should have correct styles', () {
    final InputDecoration decoration = textInputDecoration;

    expect(decoration.labelStyle!.color, equals(Colors.black));
    expect(decoration.labelStyle!.fontWeight, equals(FontWeight.w300));

    expect(decoration.focusedBorder!.borderSide.color, equals(Colors.black));
    expect(decoration.focusedBorder!.borderSide.width, equals(2));

    expect(decoration.enabledBorder!.borderSide.color, equals(Colors.black));
    expect(decoration.enabledBorder!.borderSide.width, equals(2));

    expect(decoration.errorBorder!.borderSide.color, equals(Colors.black));
    expect(decoration.errorBorder!.borderSide.width, equals(2));
  });
}
