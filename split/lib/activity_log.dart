import 'package:flutter/material.dart';
import 'main.dart';

class ActivityLogPage extends StatelessWidget {
  final List<Expense> expenses;

  const ActivityLogPage({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: expenses.isEmpty
            ? Center(
                child: Text(
                  'No activities found.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            : ListView.separated(
                itemCount: expenses.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return _ActivityItem(
                    title: expense.title,
                    amount: '₹${expense.amount.toStringAsFixed(2)}',
                    date: '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  );
                },
              ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const _ActivityItem({
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.receipt, color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(date, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500)),
            ],
          ),
        ),
        Text(amount, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}