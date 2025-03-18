import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final List<Map<String, dynamic>> _bills = [
    {
      'title': 'Electricity',
      'amount': 150.0,
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'isPaid': false,
    },
    {
      'title': 'Water',
      'amount': 75.0,
      'dueDate': DateTime.now().add(const Duration(days: 10)),
      'isPaid': false,
    },
    {
      'title': 'Internet',
      'amount': 100.0,
      'dueDate': DateTime.now().add(const Duration(days: 15)),
      'isPaid': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bills.length,
              itemBuilder: (context, index) {
                final bill = _bills[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          bill['isPaid'] ? Colors.green : Colors.red,
                      child: Icon(
                        bill['isPaid'] ? Icons.check : Icons.warning,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(bill['title']),
                    subtitle: Text(
                      'Due: ${bill['dueDate'].toString().substring(0, 10)}',
                    ),
                    trailing: Text(
                      '\$${bill['amount'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Navigate to bill details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add bill dialog
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalBills = _bills.length;
    final paidBills = _bills.where((bill) => bill['isPaid']).length;
    final totalAmount = _bills.fold<double>(
      0,
      (sum, bill) => sum + bill['amount'],
    );

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Total Bills', totalBills.toString()),
                _buildSummaryItem('Paid', paidBills.toString()),
                _buildSummaryItem(
                    'Pending', (totalBills - paidBills).toString()),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
