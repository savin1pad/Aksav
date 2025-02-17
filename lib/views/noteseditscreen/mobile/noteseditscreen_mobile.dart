// lib/pages/note_edit_page.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';
import 'package:journey/widgets/note_widget.dart';
class NoteseditscreenMobile extends StatefulWidget {
  final ZettelNote? existingNote;

  const NoteseditscreenMobile({Key? key, this.existingNote}) : super(key: key);

  @override
  State<NoteseditscreenMobile> createState() => _NoteseditscreenMobileState();
}

class _NoteseditscreenMobileState extends State<NoteseditscreenMobile> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _contentController.text = widget.existingNote!.content;
      _imageUrls = List.from(widget.existingNote!.imageUrls);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onSave,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: MentionTextField(
                      controller: _contentController,
                      hint: 'Type your note... use @ to link other notes',
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildImageRow(),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Image'),
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < _imageUrls.length; i++)
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  child: Image.network(
                    _imageUrls[i],
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _imageUrls.removeAt(i);
                      });
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    // In production: use image_picker to pick an image, upload to Firebase Storage, get download URL
    // For demo, we just add a random image from Picsum
    setState(() {
      final randomNum = Random().nextInt(1000);
      _imageUrls.add('https://picsum.photos/200?random=$randomNum');
    });
  }

  Future<void> _onSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      _showSnack('Title cannot be empty!');
      return;
    }
    if (_imageUrls.isEmpty) {
      // Mandatory at least 1 image
      _showSnack('Please add at least one image!');
      return;
    }

    final now = DateTime.now();

    if (widget.existingNote == null) {
      // create new
      final newNote = ZettelNote(
        id: '', // will be assigned by RTDB push()
        title: title,
        content: content,
        imageUrls: _imageUrls,
        createdAt: now,
        updatedAt: now,
        linkedNoteIds: [],
      );

      final created = await app<ZettelRepository>().createZettel(newNote);
      Navigator.pop(context, created);
    } else {
      // update existing
      final updatedNote = widget.existingNote!.copyWith(
        title: title,
        content: content,
        imageUrls: _imageUrls,
        updatedAt: now,
      );
      await app<ZettelRepository>().updateZettel(updatedNote);
      Navigator.pop(context, updatedNote);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
