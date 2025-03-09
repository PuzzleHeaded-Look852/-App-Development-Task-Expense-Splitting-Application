import 'package:flutter/material.dart';
import 'main.dart';

class ViewBalancePage extends StatelessWidget {
  final List<PersonBalance> balances;
  final String currentUser;

  const ViewBalancePage({
    super.key,
    required this.balances,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out current user's balance from the list
    final otherBalances = balances.where((b) => b.name != currentUser).toList();
    
    // Get current user's balance
    final currentUserBalance = balances.firstWhere(
      (b) => b.name == currentUser,
      orElse: () => PersonBalance(name: currentUser),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Balances'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _TotalBalanceCard(
              owed: currentUserBalance.owed,
              owes: currentUserBalance.owes,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: otherBalances.length,
                separatorBuilder: (context, index) => Divider(
                  height: 24,
                  color: Theme.of(context).dividerColor,
                ),
                itemBuilder: (context, index) => _BalanceListItem(
                  balance: otherBalances[index],
                  currentUser: currentUser,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalBalanceCard extends StatelessWidget {
  final double owed;
  final double owes;

  const _TotalBalanceCard({
    required this.owed,
    required this.owes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: _BalanceColumn(
                title: 'You are Owed',
                amount: owed,
                color: const Color(0xFF10B981),
              ),
            ),
            Expanded(
              child: _BalanceColumn(
                title: 'You Owe',
                amount: owes,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceColumn extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const _BalanceColumn({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _BalanceListItem extends StatelessWidget {
  final PersonBalance balance;
  final String currentUser;

  const _BalanceListItem({
    required this.balance,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate net balance from current user's perspective
    final netBalance = balance.owes - balance.owed;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        child: Text(
          balance.name[0],
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      title: Text(balance.name),
      subtitle: Text(
        netBalance > 0
            ? 'You owe ₹${netBalance.abs().toStringAsFixed(2)}'
            : 'Owes you ₹${netBalance.abs().toStringAsFixed(2)}',
      ),
      trailing: Chip(
        backgroundColor: netBalance > 0
            ? const Color(0xFFEF4444).withOpacity(0.1)
            : const Color(0xFF10B981).withOpacity(0.1),
        label: Text(
          '₹${netBalance.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: netBalance > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981),
          ),
        ),
      ),
    );
  }
}