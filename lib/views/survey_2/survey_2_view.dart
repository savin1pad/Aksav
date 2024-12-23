library survey_2_view;

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'survey_2_mobile.dart';
part 'survey_2_tablet.dart';
part 'survey_2_desktop.dart';

class Survey2View extends StatelessWidget {
  const Survey2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _Survey2Mobile(),
        desktop: const _Survey2Desktop(),
        tablet: const _Survey2Tablet(),
      );
    });
  }
}
