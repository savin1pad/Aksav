// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/get.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/models/zettelfolder.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/core/repository/zettel_repository.dart';
import 'package:journey/views/graphview/graphview_view.dart';
import 'package:journey/widgets/apptheme.dart';

class NoteNodeWidget extends StatefulWidget {
  final ZettelNote note;
  final VoidCallback onTap;
  final bool isSelected;
  final void Function(ZettelNote)? onDoubleTap;

  const NoteNodeWidget({
    Key? key,
    required this.note,
    required this.onTap,
    this.onDoubleTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<NoteNodeWidget> createState() => _NoteNodeWidgetState();
}

class _NoteNodeWidgetState extends State<NoteNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.isSelected) {
    _controller.repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05, // Much subtler pulse - reduce from 1.15
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  } else {
    // No animation for unselected nodes
    _pulseAnimation = const AlwaysStoppedAnimation(1.0);
  }
  }

  @override
void didUpdateWidget(NoteNodeWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  
  if (widget.isSelected != oldWidget.isSelected) {
    if (widget.isSelected) {
      _controller.reset();
      _controller.repeat(reverse: true);
      _pulseAnimation = Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    } else {
      _controller.stop();
      _pulseAnimation = const AlwaysStoppedAnimation(1.0);
    }
  }
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showFolderSelectionDialog(BuildContext context, List<ZettelFolder> folders) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.deepSpace.withOpacity(0.95),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppTheme.nebulaPurple.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.nebulaPurple.withOpacity(0.3),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Move to Folder',
                style: TextStyle(
                  color: AppTheme.starWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              if (folders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No folders available. Create a folder first.',
                    style: TextStyle(
                      color: AppTheme.starWhite.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(dialogContext).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      return ListTile(
                        leading: const Icon(Icons.folder, color: AppTheme.nebulaPurple),
                        title: Text(
                          folder.name,
                          style: const TextStyle(color: AppTheme.starWhite),
                        ),
                        onTap: () {
                          Navigator.pop(dialogContext);
                          _moveNoteToFolder(context, widget.note, folder);
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.starWhite.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _moveNoteToFolder(BuildContext context, ZettelNote note, ZettelFolder folder) async {
    try {
      final updatedFolder = folder.copyWith(
        noteIds: [...folder.noteIds, note.id]
      );
      
      await app<ZettelRepository>().updateFolder(updatedFolder);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note moved to ${folder.name}')),
      );
      
      // Refresh the GraphView's folder data
      if (GraphViewMobileKey.instance.currentState != null) {
  // GraphViewMobileKey.instance.currentState!._loadFolders();
}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error moving note: $e')),
      );
    }
  }

    // Update the build method to enhance the highlighted node appearance
  @override
  Widget build(BuildContext context) {
    final hasImages = widget.note.imageUrls.isNotEmpty;
    final hasLinkedNotes = widget.note.linkedNoteIds.isNotEmpty;
  
    // Calculate node size based on connections and content
    const baseSize = 60.0;
    final size =
        baseSize + (hasLinkedNotes ? 15.0 : 0.0) + (hasImages ? 10.0 : 0.0);
  
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap != null 
          ? () => widget.onDoubleTap!(widget.note)
          : null,
      onLongPress: () async {
        try {
          final folders = await app<ZettelRepository>().getUserFolders(
              RepositoryProvider.of<UserModel>(context).userId ?? '');
          if (context.mounted) {
            _showFolderSelectionDialog(context, folders);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading folders: $e')),
            );
          }
        }
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _pulseAnimation.value : 1.0,
            child: Stack(
              children: [
                // Glow effect for highlighted nodes
                if (widget.isSelected)
                  Container(
                    width: size + 20,
                    height: size + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.galaxyBlue.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: AppTheme.nebulaPurple.withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                // Main node
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.isSelected
                            ? AppTheme.galaxyBlue
                            : AppTheme.nebulaPurple,
                        AppTheme.cosmicBlue.withOpacity(0.7),
                      ],
                      radius: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isSelected
                                ? AppTheme.galaxyBlue
                                : AppTheme.nebulaPurple)
                            .withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: AppTheme.starWhite.withOpacity(widget.isSelected ? 0.9 : 0.5),
                      width: widget.isSelected ? 2.0 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show thumbnail if note has images
                        if (hasImages && widget.note.imageUrls.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              widget.note.imageUrls[0],
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            _truncateTitle(widget.note.title),
                            style: TextStyle(
                              color: AppTheme.starWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              shadows: widget.isSelected ? [
                                const Shadow(
                                  color: AppTheme.nebulaPurple,
                                  blurRadius: 4,
                                )
                              ] : [],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Show connection count indicator
                        if (hasLinkedNotes)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.isSelected 
                                  ? AppTheme.galaxyBlue.withOpacity(0.7)
                                  : AppTheme.nebulaPurple.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.note.linkedNoteIds.length.toString(),
                              style: const TextStyle(
                                color: AppTheme.starWhite,
                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Small star decorations around highlighted nodes
                if (widget.isSelected) ...[
                  for (int i = 0; i < 5; i++)
                    Positioned(
                      left: size/2 + (size/2 + 5) * cos(i * 2 * pi / 5),
                      top: size/2 + (size/2 + 5) * sin(i * 2 * pi / 5),
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppTheme.starWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.starWhite,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _truncateTitle(String title) {
    if (title.length <= 12) return title;
    return '${title.substring(0, 10)}...';
  }
}
