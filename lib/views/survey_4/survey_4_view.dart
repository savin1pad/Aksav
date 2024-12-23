library survey_4_view;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'survey_4_mobile.dart';
part 'survey_4_tablet.dart';
part 'survey_4_desktop.dart';

class Survey4View extends StatelessWidget {
  const Survey4View({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _Survey4Mobile(),
        desktop: const _Survey4Desktop(),
        tablet: const _Survey4Tablet(),
      );
    });
  }
}
