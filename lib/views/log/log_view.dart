library log_view;

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'log_mobile.dart';
part 'log_tablet.dart';
part 'log_desktop.dart';

class LogView extends StatelessWidget {
  final String goalId;
  const LogView({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _LogMobile(
          goalId: goalId,
        ),
        desktop: const _LogDesktop(),
        tablet: const _LogTablet(),
      );
    });
  }
}
