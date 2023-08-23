import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const List<IconData> iconList = [
  Icons.lunch_dining,
  Icons.flight_takeoff,
  Icons.movie,
  Icons.work
];

final categoryIcons = {
  Category.food: iconList[0],
  Category.travel: iconList[1],
  Category.leisure: iconList[2],
  Category.work: iconList[3],
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

//class to form bucket for different categories
class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  //const ExpenseBucket({required this.category, required this.expenses});

  // named constructor function
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((element) => element.category == category)
            .toList();

  double get totalExpense {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
