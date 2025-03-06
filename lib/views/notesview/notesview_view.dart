library notesview_view;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';
import 'package:journey/views/noteseditscreen/mobile/noteseditscreen_mobile.dart';
import 'package:journey/widgets/apptheme.dart';
import 'package:journey/widgets/custom_page_route.dart';
import 'package:journey/widgets/space_background.dart';
import 'package:responsive_builder/responsive_builder.dart';

part 'notesview_mobile.dart';
part 'notesview_tablet.dart';
part 'notesview_desktop.dart';

class NotesView extends StatelessWidget {
  final ZettelNote zettelNote;
  const NotesView({super.key, required this.zettelNote});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile:  _NotesViewMobile(note : zettelNote),
        desktop: const _NotesViewDesktop(),
        tablet: const _NotesViewTablet(),
      );
    });
  }
}
