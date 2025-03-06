// ignore_for_file: unused_import

library graphview_view;

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graphview/GraphView.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/models/zettelfolder.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';
import 'package:journey/views/noteseditscreen/mobile/noteseditscreen_mobile.dart';
import 'package:journey/views/notesview/notesview_view.dart';
import 'package:journey/widgets/apptheme.dart';
import 'package:journey/widgets/constellation.dart';
import 'package:journey/widgets/custom_page_route.dart';
import 'package:journey/widgets/drawer.dart';
import 'package:journey/widgets/nodewidget.dart';
import 'package:journey/widgets/separationalgorithm.dart';
import 'package:journey/widgets/space_background.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:uuid/uuid.dart';

part 'graphview_mobile.dart';
part 'graphview_tablet.dart';
part 'graphview_desktop.dart';

class GraphViewComplete extends StatelessWidget {
  final List<ZettelNote> zettelNote;
  const GraphViewComplete({super.key, required this.zettelNote});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _GraphViewMobile(
          notes: zettelNote,
        ),
        desktop: const _GraphViewDesktop(),
        tablet: const _GraphViewTablet(),
      );
    });
  }
}

class GraphViewMobileKey {
  static final instance = GlobalKey<_GraphViewMobileState>();
}