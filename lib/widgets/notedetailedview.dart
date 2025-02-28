// Updated NotesView with space theme

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/views/noteseditscreen/mobile/noteseditscreen_mobile.dart';
import 'package:journey/widgets/apptheme.dart';
import 'package:journey/widgets/space_background.dart';

class _NotesViewMobile extends StatefulWidget {
  final ZettelNote note;
  const _NotesViewMobile({Key? key, required this.note}) : super(key: key);

  @override
  State<_NotesViewMobile> createState() => _NotesViewMobileState();
}

class _NotesViewMobileState extends State<_NotesViewMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        elevation: 0,
        title: Text(
          widget.note.title,
          style: const TextStyle(
            color: AppTheme.starWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.starWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.starWhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteseditscreenMobile(
                    existingNote: widget.note,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Space background with less intensity for readability
          SpaceBackground(
            child: Container(),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Images container
                    if (widget.note.imageUrls.isNotEmpty)
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.cosmicBlue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.note.imageUrls.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final url = widget.note.imageUrls[index];
                              return Hero(
                                tag: '${widget.note.id}_image_$index',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    url,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // Note content
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.deepSpace.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.nebulaPurple.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.note.content,
                            style: const TextStyle(
                              color: AppTheme.starWhite,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Connected notes section
                          if (widget.note.linkedNoteIds.isNotEmpty) ...[
                            const Text(
                              "Connected Stars",
                              style: TextStyle(
                                color: AppTheme.starWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildConnectedNotes(),
                          ],

                          const SizedBox(height: 16),

                          // Note metadata
                          Divider(
                            color: AppTheme.nebulaPurple.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Created: ${_formatDate(widget.note.id)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.starWhite.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedNotes() {
    // In a real implementation, this would fetch the actual connected notes
    // For now, just showing the IDs
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.note.linkedNoteIds.map((noteId) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.nebulaPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.starWhite.withOpacity(0.2),
            ),
          ),
          child: Text(
            noteId.substring(0, min(noteId.length, 10)),
            style: const TextStyle(
              color: AppTheme.starWhite,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(String id) {
    // In a real app, you'd parse the actual date
    // For now, just returning the ID as a placeholder
    return id.substring(0, min(id.length, 10));
  }
}
