import 'package:flutter/material.dart';

/// Notifies screens when their tab becomes active in MainScreen.
class TabNotifier {
  static final ValueNotifier<int> index = ValueNotifier<int>(0);
}
