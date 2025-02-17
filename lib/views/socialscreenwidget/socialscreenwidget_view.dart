library socialscreenwidget_view;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';
import 'package:journey/views/graphview/graphview_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'socialscreenwidget_mobile.dart';
part 'socialscreenwidget_tablet.dart';
part 'socialscreenwidget_desktop.dart';

class SocialscreenwidgetView extends StatelessWidget {
  const SocialscreenwidgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile:  const _SocialscreenwidgetMobile(),
        desktop: const _SocialscreenwidgetDesktop(),
        tablet: const _SocialscreenwidgetTablet(),
      );
    });
  }
}