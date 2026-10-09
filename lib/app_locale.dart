import 'package:flutter/material.dart';

/// Shared language controller used by main.dart and other screens.
final ValueNotifier<Locale> appLocale =
    ValueNotifier<Locale>(const Locale('en'));
