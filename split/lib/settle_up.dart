import 'package:flutter/material.dart';
import 'main.dart'; // Ensure this import includes Person and PersonBalance

class SettleUpPage extends StatelessWidget {
  final List<PersonBalance> balances;
  final Function(Person, double) onSettle;

  const SettleUpPage({
    Key? key,
    required this.balances,
    required this.onSettle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settle Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: balances.length,
          itemBuilder: (context, index) {
            final balance = balances[index];
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
                    // Show a dialog to confirm the settlement
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Settlement'),
                          content: Text(
                              'Are you sure you want to settle ₹${balance.owes.toStringAsFixed(2)} with ${balance.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Call the onSettle callback
                                onSettle(Person(name: balance.name), balance.owes);
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
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
}
