import 'package:flutter/material.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'mobile/noteseditscreen_mobile.dart';
import 'tablet/noteseditscreen_tablet.dart';
import 'desktop/noteseditscreen_desktop.dart';

class NoteseditscreenView extends StatelessWidget {
  final ZettelNote? existingNote; 
  const NoteseditscreenView({super.key, required this.existingNote});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile:  NoteseditscreenMobile(
        existingNote: existingNote,
      ),
      tablet: const NoteseditscreenTablet(),
      desktop: const NoteseditscreenDesktop(),
    );
  }
}
