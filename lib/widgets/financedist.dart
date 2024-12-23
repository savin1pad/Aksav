// ignore_for_file: unused_field, must_be_immutable, use_build_context_synchronously

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/goals/goals_bloc.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/repository/goal_repository.dart';

class FinanceDistributionChart extends StatefulWidget {
  double totalFinance;
  FinanceDistributionChart({super.key, required this.totalFinance});

  @override
  State<FinanceDistributionChart> createState() =>
      _FinanceDistributionChartState();
}

class _FinanceDistributionChartState extends State<FinanceDistributionChart>
    with SingleTickerProviderStateMixin, LogMixin {
  int touchedIndex = -1;
  String selectedCategory = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Initial percentages
  double _needsPercentage = 50;
  double _wantsPercentage = 30;
  double _savingsPercentage = 20;

  final Map<String, Map<String, double>> detailedData = {
    'Needs': {
      'Grocery': 15,
      'Rent/Loan': 30,
      'Insurance': 25,
      'Healthcare': 10,
      'Transportation': 20,
    },
    'Wants': {
      'Restaurants': 20,
      'Travels': 15,
      'Shopping': 27,
      'Entertainment': 10,
      'Personal Care': 16,
      'Hobbies': 12,
    },
    'Savings': {
      'FD/RD/Gold': 20,
      'Mutual Funds': 20,
      'Stocks': 10,
      'Towards Goals': 50,
    },
  };

  @override
  void didUpdateWidget(FinanceDistributionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalFinance != widget.totalFinance) {
      _distributeFinances();
    }
  }

  Future<void> _distributeFinances() async {
    final user = context.read<UserModel>();
    if (user.userId != null) {
      await context
          .read<GoalRepository>()
          .distributeFinances(userId: user.userId!);
      // Refresh goals list
      context.read<GoalsBloc>().add(GoalsGetEvent(userId: user.userId!));
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showAddFinanceDialog(BuildContext context) async {
    final TextEditingController amountController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Total Finance'),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter amount to add',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get the entered amount
                double amountToAdd =
                    double.tryParse(amountController.text) ?? 0.0;

                // Update the UI
                setState(() {
                  widget.totalFinance += amountToAdd;
                });

                // Update the backend (replace with your actual backend logic)
                try {
                  context.read<GoalsBloc>().add(
                        GoalsUpdateFinanceEvent(
                          userId:
                              RepositoryProvider.of<UserModel>(context).userId!,
                          newFinance: widget.totalFinance,
                        ),
                      );

                  // Handle success (e.g., show a success message)
                } catch (e) {
                  // Handle errors (e.g., show an error message)
                  warningLog('Error updating finance: $e');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              selectedCategory.isEmpty
                  ? 'Total Finance: ${widget.totalFinance.toStringAsFixed(2)}'
                  : '$selectedCategory Breakdown',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            selectedCategory.isEmpty
                ? Expanded(
                    child: InkWell(
                    onTap: () {
                      _showAddFinanceDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Or your desired background color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize:
                            MainAxisSize.min, // Keep the button compact
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.add, color: Colors.white), // White icon
                          SizedBox(width: 8), // Spacing
                        ],
                      ),
                    ),
                  ))
                : const SizedBox.shrink(),
          ],
        ),
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                    warningLog('checking for index $touchedIndex');
                    // Handle section selection when tapped

                    final categories = ['Needs', 'Wants', 'Savings'];
                    if (touchedIndex >= 0 && touchedIndex < categories.length) {
                      selectedCategory = categories[touchedIndex];
                      _animationController.forward(from: 0);
                    }
                  });
                },
              ),
              sections: selectedCategory.isEmpty
                  ? _generateMainSections()
                  : _generateDetailedSections(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        // Show sliders only for main view
        if (selectedCategory.isEmpty) ...[
          const SizedBox(height: 0),
          _buildSlider('Needs', _needsPercentage, Colors.blue[400]!),
          _buildSlider('Wants', _wantsPercentage, Colors.green[400]!),
          _buildSlider('Savings', _savingsPercentage, Colors.orange[400]!),
        ],
        if (selectedCategory.isNotEmpty)
          TextButton.icon(
            onPressed: () {
              setState(() {
                selectedCategory = '';
                touchedIndex = -1;
                _animationController.reverse();
              });
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const Text(
              'Back to Overview',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white70),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              thumbColor: color,
              overlayColor: color.withOpacity(0.2),
              inactiveTrackColor: Colors.white24,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case 'Needs':
                      _needsPercentage = newValue;
                      _adjustOtherPercentages('needs');
                      break;
                    case 'Wants':
                      _wantsPercentage = newValue;
                      _adjustOtherPercentages('wants');
                      break;
                    case 'Savings':
                      _savingsPercentage = newValue;
                      _adjustOtherPercentages('savings');
                      break;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateMainSections() {
    return [
      _generateSection('Needs', _needsPercentage, Colors.blue[400]!, 0),
      _generateSection('Wants', _wantsPercentage, Colors.green[400]!, 1),
      _generateSection('Savings', _savingsPercentage, Colors.orange[400]!, 2),
    ];
  }

  List<PieChartSectionData> _generateDetailedSections() {
    final categoryData = detailedData[selectedCategory]!;
    return categoryData.entries.map((entry) {
      final index = categoryData.keys.toList().indexOf(entry.key);
      final baseAmount = widget.totalFinance *
          (selectedCategory == 'Needs'
              ? _needsPercentage
              : selectedCategory == 'Wants'
                  ? _wantsPercentage
                  : _savingsPercentage) /
          100;
      final amount = baseAmount * entry.value / 100;

      return _generateSection(
        entry.key,
        entry.value,
        _getSubcategoryColor(index),
        index,
        amount: amount,
      );
    }).toList();
  }

  PieChartSectionData _generateSection(
    String title,
    double value,
    Color color,
    int index, {
    double? amount,
  }) {
    final isTouched = touchedIndex == index;
    final radius = isTouched ? 70.0 : 60.0;
    final fontSize = isTouched ? 16.0 : 14.0;

    return PieChartSectionData(
      color: color,
      value: value,
      title: amount != null
          ? '$title\n ${amount.toStringAsFixed(2)}'
          : '$title\n${value.round()}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Color _getSubcategoryColor(int index) {
    final baseColor = selectedCategory == 'Needs'
        ? Colors.purple
        : selectedCategory == 'Wants'
            ? Colors.green
            : Colors.orange;

    final shades = [300, 400, 500, 600, 700, 800];
    return baseColor[shades[index % shades.length]]!;
  }

  void _adjustOtherPercentages(String changedSlider) {
    const double total = 100;
    switch (changedSlider) {
      case 'needs':
        final remaining = total - _needsPercentage;
        if (remaining >= 0) {
          final ratio =
              _wantsPercentage / (_wantsPercentage + _savingsPercentage);
          _wantsPercentage = remaining * ratio;
          _savingsPercentage = remaining * (1 - ratio);
        }
        break;
      case 'wants':
        final remaining = total - _wantsPercentage;
        if (remaining >= 0) {
          final ratio =
              _needsPercentage / (_needsPercentage + _savingsPercentage);
          _needsPercentage = remaining * ratio;
          _savingsPercentage = remaining * (1 - ratio);
        }
        break;
      case 'savings':
        final remaining = total - _savingsPercentage;
        if (remaining >= 0) {
          final ratio =
              _needsPercentage / (_needsPercentage + _wantsPercentage);
          _needsPercentage = remaining * ratio;
          _wantsPercentage = remaining * (1 - ratio);
        }
        break;
    }
    if (changedSlider == 'savings') {
      context.read<GoalRepository>().distributeFinances(
            userId: RepositoryProvider.of<UserModel>(context).userId!,
          );
    }
  }
}
