library survey_stack_view;

// import 'dart:io';

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:card_swiper/card_swiper.dart' as card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/data/data_bloc.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/services/navigator_service.dart';
import 'package:journey/global/constants.dart';
import 'package:journey/views/rememberour/rememberour_view.dart';
import 'package:journey/views/survey_1/survey_1_view.dart';
import 'package:journey/views/survey_2/survey_2_view.dart';
import 'package:journey/views/survey_3/survey_3_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

part 'survey_stack_mobile.dart';
part 'survey_stack_tablet.dart';
part 'survey_stack_desktop.dart';

class SurveyStackView extends StatelessWidget {
  final String email;
  final String userId;
  final String documentId;
  const SurveyStackView(
      {super.key,
      required this.documentId,
      required this.email,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _SurveyStackMobile(
          email: email,
          userId: userId,
          documentId: documentId,
        ),
        desktop: const _SurveyStackDesktop(),
        tablet: const _SurveyStackTablet(),
      );
    });
  }
}
