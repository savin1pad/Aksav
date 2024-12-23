library rememberour_view;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/goals/goals_bloc.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/finance_model.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/services/navigator_service.dart';
import 'package:journey/global/constants.dart';
import 'package:journey/views/home/home_view.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

part 'rememberour_mobile.dart';
part 'rememberour_tablet.dart';
part 'rememberour_desktop.dart';

class RememberourView extends StatelessWidget {
  final String email;
  final String userId;
  final String documentId;
  const RememberourView(
      {super.key,
      required this.email,
      required this.userId,
      required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _RememberourMobile(
          email: email,
          userId: userId,
          documentId: documentId,
        ),
        desktop: const _RememberourDesktop(),
        tablet: const _RememberourTablet(),
      );
    });
  }
}
