library loginbuffer_view;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/auth/auth_bloc.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/services/navigator_service.dart';
import 'package:journey/global/constants.dart';
import 'package:journey/views/home/home_view.dart';
import 'package:journey/views/survey_stack/survey_stack_view.dart';
// import 'package:journey/views/home/home_view.dart';
// import 'package:journey/views/onboarding/onboarding_view.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'loginbuffer_mobile.dart';
part 'loginbuffer_tablet.dart';
part 'loginbuffer_desktop.dart';

class LoginbufferView extends StatelessWidget {
  const LoginbufferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _LoginbufferMobile(),
        desktop: const _LoginbufferDesktop(),
        tablet: const _LoginbufferTablet(),
      );
    });
  }
}
