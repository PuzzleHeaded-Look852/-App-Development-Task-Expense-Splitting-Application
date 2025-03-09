import 'package:flutter/material.dart';
import 'main.dart';

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
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: balances.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(balances[index].name),
              subtitle: Text('Owes: ₹${balances[index].owes.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Implement settlement logic
                  double amountToSettle = balances[index].owes; // Example amount
                  onSettle(balances[index].name as Person, amountToSettle);
                },
                child: const Text('Settle'),
              ),
            );
          },
        ),
      ),
    );
  }
}