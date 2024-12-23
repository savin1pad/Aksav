library login_view;

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:journey/core/blocs/auth/auth_bloc.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/services/navigator_service.dart';
import 'package:journey/global/constants.dart';
import 'package:journey/views/home/home_view.dart';
// import 'package:journey/theme/theme.dart';
// import 'package:journey/views/forgot_password/forgot_password_view.dart';
// import 'package:journey/views/home/home_view.dart';
// import 'package:journey/views/onboarding/onboarding_view.dart';
import 'package:journey/views/survey_stack/survey_stack_view.dart';
// import 'package:journey/views/onboarding/onboarding_view.dart';
// import 'package:journey/views/phone_auth/phone_auth_view.dart';
// import 'package:journey/views/signup/signup_view.dart';
// import 'package:journey/widgets/custom_container.dart';
import 'package:journey/widgets/dialogbox.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
// import 'package:validators/validators.dart';

part 'login_mobile.dart';
part 'login_tablet.dart';
part 'login_desktop.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _LoginMobile(),
        desktop: _LoginDesktop(),
        tablet: _LoginTablet(),
      );
    });
  }
}
