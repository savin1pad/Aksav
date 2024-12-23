library survey_3_view;

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/goal_model.dart';

import 'package:journey/core/repository/storage_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'survey_3_mobile.dart';
part 'survey_3_tablet.dart';
part 'survey_3_desktop.dart';

class Survey3View extends StatelessWidget {
  const Survey3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _Survey3Mobile(),
        desktop: const _Survey3Desktop(),
        tablet: const _Survey3Tablet(),
      );
    });
  }
}
