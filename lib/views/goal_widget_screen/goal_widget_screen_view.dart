library goal_widget_screen_view;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/chat/chat_bloc.dart';
import 'package:journey/core/blocs/goal_log/goal_log_bloc.dart';
import 'package:journey/core/blocs/goals/goals_bloc.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/repository/chat_repository.dart';
import 'package:journey/core/repository/goal_log_repository.dart';
import 'package:journey/widgets/chat_widget.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'goal_widget_screen_mobile.dart';
part 'goal_widget_screen_tablet.dart';
part 'goal_widget_screen_desktop.dart';

class GoalWidgetScreenView extends StatelessWidget {
  final GoalModel goalModel;
  const GoalWidgetScreenView({super.key, required this.goalModel});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _GoalWidgetScreenMobile(
          goalModel: goalModel,
        ),
        desktop: const _GoalWidgetScreenDesktop(),
        tablet: const _GoalWidgetScreenTablet(),
      );
    });
  }
}
