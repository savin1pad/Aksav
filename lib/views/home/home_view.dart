library home_view;

import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/goals/goals_bloc.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/repository/goal_repository.dart';
import 'package:journey/core/services/navigator_service.dart';
import 'package:journey/global/constants.dart';

import 'package:journey/views/login/login_view.dart';
import 'package:journey/views/survey_stack/survey_stack_view.dart';
import 'package:journey/widgets/financedist.dart';
import 'package:journey/widgets/goal_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

import '../../core/blocs/auth/auth_bloc.dart';

part 'home_mobile.dart';
part 'home_tablet.dart';
part 'home_desktop.dart';

class HomeView extends StatelessWidget {
  final String email;
  final String userId;
  final String documentId;
  const HomeView(
      {super.key,
      required this.email,
      required this.userId,
      required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HomeMobile(
          email: email,
          userId: userId,
          documentId: documentId,
        ),
        desktop: _HomeDesktop(),
        tablet: _HomeTablet(),
      );
    });
  }
}
