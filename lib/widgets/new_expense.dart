import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    //close the overlay after new expense added
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    // LayoutBuilder give us the constraints applied by parent
    // this function is called when constraints change
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      // title widget
      final titleWidget = TextField(
        controller: _titleController,
        maxLength: 50,
        decoration: const InputDecoration(
          label: Text('Title'),
        ),
      );

      // amount widget
      final amountWidget = Expanded(
        child: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: '\$ ',
            label: Text('Amount'),
          ),
        ),
      );

      // category widget
      final categoryWidget = DropdownButton(
        value: _selectedCategory,
        items: Category.values
            .map(
              (category) => DropdownMenuItem(
                value: category,
                child: Text(
                  category.name.toUpperCase(),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _selectedCategory = value;
          });
        },
      );

      // date widget
      final dateWidget = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null
                ? 'No date selected'
                : formatter.format(_selectedDate!),
          ),
          IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(
              Icons.calendar_month,
            ),
          ),
        ],
      );

      // cancel button
      final cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      );

      // save button
      final saveButton = ElevatedButton(
        onPressed: _submitExpenseData,
        child: const Text('Save Expense'),
      );

      // return statement
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                // for landscape orientation
                if (width >= 600)
                  // first row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: titleWidget),
                      const SizedBox(width: 24),
                      amountWidget,
                    ],
                  )

                // for potraint orientation
                else
                  titleWidget,

                // second row
                Row(
                  children: [
                    // for landscape orientation
                    if (width >= 600)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            categoryWidget,
                            const SizedBox(width: 48),

                            dateWidget,
                            const SizedBox(width: 24),
                            Expanded(
                                child: Row(
                              children: [
                                const Spacer(),
                                cancelButton,
                                saveButton
                              ],
                            )),
                            //cancelButton,
                            //saveButton,
                          ],
                        ),
                      )
                    // for potrait orientation
                    else
                      Expanded(
                          child: Row(
                        children: [amountWidget, dateWidget],
                      )),
                  ],
                ),
                const SizedBox(height: 16),
                // third row
                Row(
                  children: [
                    if (width >= 600)
                      const Text('')
                    else
                      Expanded(
                        child: Row(
                          children: [
                            categoryWidget,
                            Expanded(
                              child: Row(
                                children: [
                                  const Spacer(),
                                  cancelButton,
                                  saveButton
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
