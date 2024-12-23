library formforgoal_view;

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/global/constants.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

part 'formforgoal_mobile.dart';
part 'formforgoal_tablet.dart';
part 'formforgoal_desktop.dart';

class FormforgoalView extends StatelessWidget {
  const FormforgoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _FormforgoalMobile(),
        desktop: const _FormforgoalDesktop(),
        tablet: const _FormforgoalTablet(),
      );
    });
  }
}
