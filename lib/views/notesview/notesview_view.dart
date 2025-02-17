library notesview_view;

import 'package:flutter/material.dart';
import 'package:journey/core/models/zettelnote.dart';
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
