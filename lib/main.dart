import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_tracker/widgets/expenses.dart';

final kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

final kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MaterialApp(
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          //theme for card
          cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.inversePrimary,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          // theme for elevated button
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer,
            ),
          ),
        ),
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          //theme for app bar
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onSurface,
          ),
          //theme for card
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.inversePrimary,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          // theme for elevated button
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
                titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onPrimaryContainer,
                  fontSize: 18,
                ),
              ),
        ),
        home: const Expenses(),
      ),
    ),
  );
}
