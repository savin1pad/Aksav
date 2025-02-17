// lib/widgets/mention_text_field.dart
import 'package:flutter/material.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';

class MentionTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const MentionTextField({
    Key? key,
    required this.controller,
    this.hint = '',
    this.maxLines = 5,
  }) : super(key: key);

  @override
  State<MentionTextField> createState() => _MentionTextFieldState();
}

class _MentionTextFieldState extends State<MentionTextField> {
  final _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<ZettelNote> _mentionResults = [];

  // Tracks the index of '@' in the text so we know where to insert the mention
  int? _atSymbolIndex;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() async {
    final text = widget.controller.text;
    final cursorPos = widget.controller.selection.baseOffset;
    if (cursorPos < 0) return;

    // Check if there's an '@' behind the cursor
    final lastAt = text.lastIndexOf('@', cursorPos);
    if (lastAt == -1) {
      _atSymbolIndex = null;
      _removeOverlay();
      return;
    }

    final query = text.substring(lastAt + 1, cursorPos).trim();
    if (query.isNotEmpty) {
      _atSymbolIndex = lastAt;
      // Query Realtime DB for matching titles
      final results = await app<ZettelRepository>().searchNotesByTitle(text);
      setState(() {
        _mentionResults = results;
      });
      if (_mentionResults.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      // if user typed '@' but no text yet
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height,
          width: size.width,
          child: Material(
            elevation: 2,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _mentionResults.length,
              itemBuilder: (context, index) {
                final note = _mentionResults[index];
                return ListTile(
                  title: Text(note.title),
                  onTap: () => _onMentionSelected(note),
                );
              },
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onMentionSelected(ZettelNote note) {
    // Insert mention into the text
    final text = widget.controller.text;
    final cursorPos = widget.controller.selection.baseOffset;
    if (cursorPos < 0 || _atSymbolIndex == null) return;

    final mentionText = '@${note.title} ';
    final newText = text.replaceRange(_atSymbolIndex!, cursorPos, mentionText);

    setState(() {
      widget.controller.text = newText;
      widget.controller.selection = TextSelection.collapsed(
        offset: _atSymbolIndex! + mentionText.length,
      );
      _atSymbolIndex = null;
    });

    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}