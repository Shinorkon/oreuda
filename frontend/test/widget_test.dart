import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oreuda/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const OreudaApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
