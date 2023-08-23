import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/bars/bar.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key, required this.totalExpenses});

  final List<Expense> totalExpenses;

  // return bottom icons based on the value given
  Widget getBottomTitles(double value, TitleMeta meta) {
    return Icon(iconList[value.round()]);
  }

  //initialize expense bucket
  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(totalExpenses, Category.food),
      ExpenseBucket.forCategory(totalExpenses, Category.leisure),
      ExpenseBucket.forCategory(totalExpenses, Category.travel),
      ExpenseBucket.forCategory(totalExpenses, Category.work),
    ];
  }

  // initialize individual bars
  List<Bar> getBarData(List<ExpenseBucket> ex) {
    return [
      Bar(x: 0, y: ex[0].totalExpense),
      Bar(x: 1, y: ex[1].totalExpense),
      Bar(x: 2, y: ex[2].totalExpense),
      Bar(x: 3, y: ex[3].totalExpense)
    ];
  }

  // get max value
  double getMax(List<ExpenseBucket> ex) {
    return [
      ex[0].totalExpense,
      ex[1].totalExpense,
      ex[2].totalExpense,
      ex[3].totalExpense
    ].reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    // list of expense buckets
    final expenseBuckets = buckets;
    // max value
    final maxValue = getMax(expenseBuckets);
    // list of individual bars
    final barData = getBarData(expenseBuckets);

    return Expanded(
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: (maxValue / 10).ceil() * 10,
          gridData: const FlGridData(show: false), // remove grids
          borderData:
              FlBorderData(show: false), // remove borders around bargraph
          // remove titles from top and left
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            )),
          ),
          barGroups: barData
              .map((bar) => BarChartGroupData(x: bar.x, barRods: [
                    BarChartRodData(
                      toY: bar.y,
                      color: Theme.of(context).colorScheme.primary,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxValue,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.3),
                      ),
                    ),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
