// lib/pages/note_edit_page.dart
// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_field, unused_local_variable, unnecessary_null_comparison, unused_element

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';
import 'package:journey/widgets/space_background.dart';
import 'package:uuid/uuid.dart';

class NoteseditscreenMobile extends StatefulWidget {
  final ZettelNote? existingNote;

  const NoteseditscreenMobile({Key? key, this.existingNote}) : super(key: key);

  @override
  State<NoteseditscreenMobile> createState() => _NoteseditscreenMobileState();
}

class _NoteseditscreenMobileState extends State<NoteseditscreenMobile>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<File> _imageUrls = [];
  List<File> _videoUrls = [];
  List<ZettelNote> allNotes = [];
  OverlayEntry? _overlayEntry;

  String currentMention = '';

  List<String> _linkedNoteIds = [];

  late AnimationController _animationcontroller;
  late Animation<double> _titleAnimation;
  late Animation<double> _contentAnimation;
  late Animation<double> _imageAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationcontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fetchAllNotes();
    _titleAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationcontroller, curve: Curves.easeOutBack));
    _contentAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationcontroller, curve: Curves.easeOutBack));
    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationcontroller, curve: Curves.easeIn));
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationcontroller, curve: Curves.easeOutBack));

    _animationcontroller.forward();

    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _contentController.text = widget.existingNote!.content;
      _imageUrls = List.from(widget.existingNote!.imageUrls);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _fetchAllNotes() async {
    try {
      allNotes = await RepositoryProvider.of<ZettelRepository>(context)
          .getUserZettels(
              RepositoryProvider.of<UserModel>(context).userId ?? '');
      log('Checking for the notes $allNotes');
    } catch (e) {
      allNotes = [];
      log('Error fetching notes: $e');
    }
  }

  // Add this method to _NoteseditscreenMobileState
  void _showReferenceNotesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.deepPurpleAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.link, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 10),
                    const Text(
                      'Reference a Note',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              Divider(
                  color: Colors.deepPurpleAccent.withOpacity(0.5), height: 1),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // Filter notes (would need to be implemented)
                  },
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final note = allNotes[index];
                    return Card(
                      color: Colors.deepPurple.withOpacity(0.2),
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Colors.deepPurpleAccent.withOpacity(0.3)),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurpleAccent.withOpacity(0.7)),
                          child: const Icon(Icons.star,
                              color: Colors.white, size: 18),
                        ),
                        title: Text(
                          note.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Insert reference at cursor position
                          final currentText = _contentController.text;
                          final cursorPos =
                              _contentController.selection.baseOffset;
                          if (cursorPos >= 0) {
                            final before = currentText.substring(0, cursorPos);
                            final after = currentText.substring(cursorPos);
                            _contentController.text =
                                '$before@[${note.title}] $after';
                            _contentController.selection =
                                TextSelection.collapsed(
                              offset: cursorPos + note.title.length + 3,
                            );
                          }
                          // Add to linked notes
                          if (!_linkedNoteIds.contains(note.id)) {
                            _linkedNoteIds.add(note.id);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() {
        _imageUrls.add(file);
      });
    }
  }

  Future<void> _pickVideo(bool fromCamera) async {
    final pickedVideo = await _picker.pickVideo(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxDuration: const Duration(minutes: 1));
    if (pickedVideo != null) {
      File file = File(pickedVideo.path);
      setState(() {
        _videoUrls.add(file);
      });
    }
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and content'),
        ),
      );
      return;
    }
    final newNote = ZettelNote(
      id: const Uuid().v4(),
      title: title,
      content: content,
      userId: RepositoryProvider.of<UserModel>(context).userId ?? '',
      imageUrls: _imageUrls,
      videoUrls: _videoUrls,
      linkedNoteIds: _linkedNoteIds,
    );
    app<ZettelRepository>().createZettel(newNote);
    Navigator.of(context).pop(newNote);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;
    log('Checking for the userId $allNotes');
    return Scaffold(
        backgroundColor: Colors.black,
        body: SpaceBackground(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: AnimatedBuilder(
                        animation: _animationcontroller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_titleAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                              labelText: 'Note Title',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white70,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white70,
                                ),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // In the build method, replace the content TextField with:

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: AnimatedBuilder(
                        animation: _animationcontroller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _contentAnimation.value),
                            child: child,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _contentController,
                              maxLines: 20,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Note content',
                                labelStyle: TextStyle(color: Colors.white70),
                                alignLabelWithHint: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white70,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _showReferenceNotesDialog,
                                  icon: const Icon(Icons.link,
                                      color: Colors.white, size: 16),
                                  label: const Text(
                                    'Link Note',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    _imageUrls.isNotEmpty
                        ? FadeTransition(
                            opacity: _imageAnimation,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _imageUrls
                                    .map((imgFile) => Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                imgFile,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: -8,
                                              right: -8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _imageUrls.remove(imgFile);
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.redAccent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _videoUrls.isNotEmpty
                        ? FadeTransition(
                            opacity: _imageAnimation,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _videoUrls
                                    .map(
                                      (videoFile) => Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.videocam,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Positioned(
                                            top: -8,
                                            right: -8,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _videoUrls.remove(videoFile);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                decoration: const BoxDecoration(
                                                  color: Colors.redAccent,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 8.0,
                    ),
                    AnimatedBuilder(
                      animation: _animationcontroller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _imageAnimation.value,
                          child: Transform.scale(
                            scale: _imageAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _showImageSourceDialog(false);
                            },
                            label: const Text(
                              'Add Image',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.deepPurpleAccent,
                              backgroundColor: Colors.deepPurpleAccent,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showImageSourceDialog(true);
                            },
                            label: const Text(
                              'Add Video',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.videocam,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.deepPurpleAccent,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: AnimatedBuilder(
                        animation: _animationcontroller,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _imageAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 20 * (1 - _imageAnimation.value)),
                              child: child,
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Save Note',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _saveNote,
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.deepPurpleAccent,
                                backgroundColor: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 10,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 18.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ));
  }

  void _showImageSourceDialog(bool isVideo) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isVideo ? 'Add Video' : 'Add Image',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (isVideo) {
                            _pickVideo(true);
                          } else {
                            _pickImage(true);
                          }
                        },
                        label: const Text('Camera'),
                        icon: const Icon(Icons.camera_alt),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (isVideo) {
                            _pickVideo(false);
                          } else {
                            _pickImage(false);
                          }
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}
