import 'package:flutter/material.dart';
import 'package:split/add_expense.dart';
import 'package:split/view_balance.dart';
import 'package:split/settle_up.dart';
import 'package:split/activity_log.dart'; // Import the ActivityLogPage

void main() {
  runApp(const SplitApp());
}

class SplitApp extends StatefulWidget {
  const SplitApp({super.key});

  @override
  State<SplitApp> createState() => _SplitAppState();
}

class _SplitAppState extends State<SplitApp> {
  bool _isDarkMode = true;
  final String _currentUser = "You"; // Set your username here

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2F2F2F),
      secondary: Color(0xFF6366F1),
      surface: Color(0xFFF8FAFC),
      background: Color(0xFFFFFFFF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8FAFC),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFF2F2F2F),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: Color(0xFF2F2F2F)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: -0.25,
        ),
        elevation: 0,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFF2F2F2F),
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.75,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF64748B),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF2F2F2F),
        fontSize: 14,
        letterSpacing: -0.1,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF2F2F2F)), // Set label color
      hintStyle: TextStyle(color: Color(0xFF64748B)), // Set hint text color
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2F2F2F)), // Set border color
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF6366F1)), // Set focused border color
      ),
    ),
    dividerColor: Colors.grey.shade200,
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE0E0E0),
      secondary: Color(0xFF818CF8),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF818CF8),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: -0.25,
        ),
        elevation: 0,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1E1E1E),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.75,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 14,
        letterSpacing: -0.1,
      ),
    ),
    dividerColor: Colors.grey.shade800,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Split',
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: HomePage(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
        currentUser: _currentUser, // Pass the currentUser here
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Person {
  late final String name;
  Person({required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class Expense {
  final String title;
  final double amount;
  final DateTime date;
  final List<Person> participants;
  final Person paidBy;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.participants,
    required this.paidBy,
  });
}

class PersonBalance {
  final String name;
  double owed;
  double owes;

  PersonBalance({
    required this.name,
    this.owed = 0,
    this.owes = 0,
  });
}

class Settlement {
  final Person from;
  final Person to;
  final double amount;
  final DateTime date;

  Settlement({
    required this.from,
    required this.to,
    required this.amount,
    required this.date,
  });
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String currentUser;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.currentUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> _expenses = [];
  List<PersonBalance> _balances = [];
  List<Settlement> _settlements = [];

  void _addExpense(Expense newExpense) {
    setState(() {
      _expenses.add(newExpense);
      _calculateBalances();
    });
  }

  void _calculateBalances() {
    Map<String, PersonBalance> balanceMap = {};

    for (var expense in _expenses) {
      final share = expense.amount / expense.participants.length;

      // Update payer's balance
      balanceMap.update(
        expense.paidBy.name,
        (b) => PersonBalance(name: b.name, owed: b.owed + expense.amount, owes: b.owes),
        ifAbsent: () => PersonBalance(name: expense.paidBy.name, owed: expense.amount),
      );

      // Update participants' balances
      for (var participant in expense.participants) {
        if (participant != expense.paidBy) {
          balanceMap.update(
            participant.name,
            (b) => PersonBalance(name: b.name, owed: b.owed, owes: b.owes + share),
            ifAbsent: () => PersonBalance(name: participant.name, owes: share),
          );
        }
      }
    }

    _balances = balanceMap.values.toList();
  }

  void _handleSettlement(Person person, double amount) {
    setState(() {
      _settlements.add(Settlement(
        from: Person(name: widget.currentUser),
        to: person,
        amount: amount,
        date: DateTime.now(),
      ));

      // Update balances
      final payerBalance = _balances.firstWhere(
        (b) => b.name == widget.currentUser,
        orElse: () => PersonBalance(name: widget.currentUser),
      );

      final receiverBalance = _balances.firstWhere(
        (b) => b.name == person.name,
        orElse: () => PersonBalance(name: person.name),
      );

      payerBalance.owes -= amount;
      receiverBalance.owed -= amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Balance Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Balance Overview',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _BalanceCard(
                              title: 'You Owe',
                              amount: '₹${_balances.fold(0.0, (sum, b) => sum + b.owes).toStringAsFixed(2)}',
                              color: const Color(0xFFEF4444),
                              icon: Icons.arrow_circle_down_rounded,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _BalanceCard(
                              title: 'You are Owed',
                              amount: '₹${_balances.fold(0.0, (sum, b) => sum + b.owed).toStringAsFixed(2)}',
                              color: const Color(0xFF10B981),
                              icon: Icons.arrow_circle_up_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _ActionButton(
                    icon: Icons.add_chart_rounded,
                    label: 'Add Expense',
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExpensePage(onAddExpense: _addExpense),
                        ),
                      ).then((_) {
                        // Recalculate balances when returning from AddExpensePage
                        setState(() {
                          _calculateBalances();
                        });
                      });
                    },
                  ),
                  _ActionButton(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'View Balances',
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewBalancePage(
                            balances: _balances,
                            currentUser: widget.currentUser,
                          ),
                        ),
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.currency_exchange_rounded,
                    label: 'Settle Up',
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettleUpPage(
                            balances: _balances,
                            onSettle: _handleSettlement,
                          ),
                        ),
                      ).then((_) {
                        // Recalculate balances when returning from SettleUpPage
                        setState(() {
                          _calculateBalances();
                        });
                      });
                    },
                  ),
                  _ActionButton(
                    icon: Icons.history_rounded,
                    label: 'Activity Log',
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityLogPage(expenses: _expenses), // Navigate to Activity Log
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Recent Activity',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Icon(Icons.more_horiz_rounded, color: Theme.of(context).textTheme.bodyMedium?.color),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _expenses.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 24,
                          color: Theme.of(context).dividerColor,
                        ),
                        itemBuilder: (context, index) => _ActivityItem(
                          title: _expenses[index].title,
                          amount: '₹${_expenses[index].amount.toStringAsFixed(2)}',
                          date: '${_expenses[index].date.day}/${_expenses[index].date.month}/${_expenses[index].date.year}',
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _BalanceCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
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
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      onPressed: onPressed,
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final bool isDarkMode;

  const _ActivityItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.restaurant_rounded, color: Theme.of(context).textTheme.bodyMedium?.color),
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
