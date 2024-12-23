// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/services/navigator_service.dart';
import 'package:journey/views/goal_widget_screen/goal_widget_screen_view.dart';
import 'package:lottie/lottie.dart';

class GoalWidget extends StatefulWidget {
  final GoalModel goal;
  final Function(bool) onSocialToggle;

  const GoalWidget({
    super.key,
    required this.goal,
    required this.onSocialToggle,
  });

  @override
  State<GoalWidget> createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget> {
  bool _showCelebration = false;

  @override
  void didUpdateWidget(GoalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if goal just completed, with proper null checks
    if (!(oldWidget.goal.isCompleted ?? false) &&
        (widget.goal.isCompleted ?? false)) {
      setState(() => _showCelebration = true);
      // Hide celebration after animation
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showCelebration = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (widget.goal.allocatedAmount ?? 0) / (widget.goal.targetAmount ?? 1);
    final percentage = (progress * 100).toInt();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$percentage% Complete',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.goal.isSocial ?? false
                        ? Icons.public
                        : Icons.public_off,
                    color: widget.goal.isSocial ?? false
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () =>
                      widget.onSocialToggle(!(widget.goal.isSocial ?? false)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage >= 100 ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: percentage >= 100 ||
                              (widget.goal.isCompleted ?? false)
                          ? Lottie.asset(
                              'assets/check.json',
                              fit: BoxFit.cover,
                              repeat: true,
                            )
                          : Image(
                              image: widget.goal.photoUrl != null
                                  ? NetworkImage(widget.goal.photoUrl!)
                                  : const AssetImage('assets/icon.jpeg')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.goal.goal ?? 'No description',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.goal.allocatedAmount ?? 0}/${widget.goal.targetAmount ?? 0}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  app<NavigatorService>().buildAndPush(
                    GoalWidgetScreenView(goalModel: widget.goal),
                  );
                },
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
