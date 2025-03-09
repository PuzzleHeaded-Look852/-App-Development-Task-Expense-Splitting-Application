import 'package:flutter/material.dart';
import 'main.dart';

class AddExpensePage extends StatefulWidget {
  final Function(Expense) onAddExpense;

  const AddExpensePage({super.key, required this.onAddExpense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  List<Person> _participants = [];
  Person? _payer;
  List<TextEditingController> _participantControllers = [];

  @override
  void initState() {
    super.initState();
    _addParticipantField(); // Start with one participant field
  }

  void _addParticipantField() {
    _participantControllers.add(TextEditingController());
    _participants.add(Person(name: '')); // Add empty person object
    setState(() {});
  }

  void _removeParticipantField(int index) {
    setState(() {
      if (_participantControllers.length > 1) {
        _participantControllers.removeAt(index);
        _participants.removeAt(index);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // Update participant names from controllers
      List<Person> validParticipants = [];
      for (int i = 0; i < _participantControllers.length; i++) {
        String name = _participantControllers[i].text.trim();
        if (name.isNotEmpty) {
          validParticipants.add(Person(name: name));
        }
      }

      if (validParticipants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one participant with a name.')),
        );
        return;
      }

      if (_payer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select who paid the expense.')),
        );
        return;
      }

      widget.onAddExpense(
        Expense(
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          date: _selectedDate!,
          participants: validParticipants,
          paidBy: _payer!,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    for (var controller in _participantControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Set text color
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54), // Label color
                    hintText: 'Enter title',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white30 : Colors.black38), // Hint color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Set text color
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54), // Label color
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white30 : Colors.black38), // Hint color
                    prefixText: '₹ ', // Add Rupee symbol as prefix
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'No Date Selected'
                        : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Set text color
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Participants',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _participantControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _participantControllers[index],
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Set text color
                              decoration: InputDecoration(
                                labelText: 'Participant Name',
                                labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54), // Label color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (value) {
                                _participants[index] = Person(name: value);
                              },
                              validator: (value) {
                                if (index == 0 && (value == null || value.isEmpty)) {
                                  return 'Please enter at least one participant name';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (_participantControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => _removeParticipantField(index),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addParticipantField,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Participant'),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Person>(
                  decoration: InputDecoration(
                    labelText: 'Paid By',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54), // Label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: _payer,
                  items: _participants.map((person) {
                    return DropdownMenuItem<Person>(
                      value: person,
                      child: Text(
                        person.name.isNotEmpty ? person.name : 'Participant Name',
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Set text color
                      ),
                    );
                  }).toList(),
                  onChanged: (Person? newValue) {
                    setState(() {
                      _payer = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select who paid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Expense'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
