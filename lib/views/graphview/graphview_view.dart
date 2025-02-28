library graphview_view;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:graphview/GraphView.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/views/noteseditscreen/mobile/noteseditscreen_mobile.dart';
import 'package:journey/views/notesview/notesview_view.dart';
import 'package:journey/widgets/apptheme.dart';
import 'package:journey/widgets/custom_page_route.dart';
import 'package:journey/widgets/nodewidget.dart';
import 'package:journey/widgets/space_background.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
