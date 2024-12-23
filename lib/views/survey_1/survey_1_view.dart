library survey_1_view;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'survey_1_mobile.dart';
part 'survey_1_tablet.dart';
part 'survey_1_desktop.dart';

class Survey1View extends StatelessWidget {
  const Survey1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _Survey1Mobile(),
        desktop: const _Survey1Desktop(),
        tablet: const _Survey1Tablet(),
      );
    });
  }
}
