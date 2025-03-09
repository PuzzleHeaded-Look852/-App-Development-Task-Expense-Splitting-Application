import 'package:flutter/material.dart';
import 'main.dart'; // Ensure this import includes Person and PersonBalance

class SettleUpPage extends StatefulWidget {
  final List<PersonBalance> balances;
  final Function(Person, double) onSettle;

  const SettleUpPage({
    Key? key,
    required this.balances,
    required this.onSettle,
  }) : super(key: key);

  @override
  _SettleUpPageState createState() => _SettleUpPageState();
}

class _SettleUpPageState extends State<SettleUpPage> {
  late List<PersonBalance> _balances;

  @override
  void initState() {
    super.initState();
    _balances = List.from(widget.balances); // Create a copy of the balances
  }

  void _updateBalance(Person person, double amount) {
    setState(() {
      final index = _balances.indexWhere((balance) => balance.name == person.name);
      if (index != -1) {
        if (_balances[index].owes >= 0) {
          _balances[index] = PersonBalance(
            name: _balances[index].name,
            owes: _balances[index].owes - amount,
          );
        } else {
          _balances[index] = PersonBalance(
            name: _balances[index].name,
            owes: _balances[index].owes + amount,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settle Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _balances.length,
          itemBuilder: (context, index) {
            final balance = _balances[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  balance.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  balance.owes >= 0
                      ? 'Owes: ₹${balance.owes.toStringAsFixed(2)}'
                      : 'Is owed: ₹${(-balance.owes).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: balance.owes >= 0 ? Colors.red : Colors.green,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Show a dialog to settle the amount
                    _showSettleDialog(context, balance);
                  },
                  child: const Text('Settle'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSettleDialog(BuildContext context, PersonBalance balance) {
    final TextEditingController _amountController = TextEditingController();
    final double maxAmount = balance.owes >= 0 ? balance.owes : -balance.owes;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settle Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                balance.owes >= 0
                    ? '${balance.name} owes you ₹${balance.owes.toStringAsFixed(2)}.'
                    : 'You owe ${balance.name} ₹${(-balance.owes).toStringAsFixed(2)}.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount to Settle',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0 || amount > maxAmount) {
                    return 'Please enter a valid amount (up to ₹${maxAmount.toStringAsFixed(2)})';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate and process the settlement amount
                final amount = double.tryParse(_amountController.text);
                if (amount != null && amount > 0 && amount <= maxAmount) {
                  widget.onSettle(Person(name: balance.name), amount);
                  _updateBalance(Person(name: balance.name), amount);
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a valid amount (up to ₹${maxAmount.toStringAsFixed(2)})',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
