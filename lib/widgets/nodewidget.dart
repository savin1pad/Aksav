import 'package:flutter/material.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/widgets/apptheme.dart';

class NoteNodeWidget extends StatefulWidget {
  final ZettelNote note;
  final VoidCallback onTap;
  final bool isSelected;

  const NoteNodeWidget({
    Key? key,
    required this.note,
    required this.onTap,
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

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.note.imageUrls.isNotEmpty;
    final hasLinkedNotes = widget.note.linkedNoteIds.isNotEmpty;

    // Calculate node size based on connections and content
    const baseSize = 70.0;
    final size =
        baseSize + (hasLinkedNotes ? 15.0 : 0.0) + (hasImages ? 10.0 : 0.0);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _pulseAnimation.value : 1.0,
            child: Container(
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
                  color: AppTheme.starWhite.withOpacity(0.5),
                  width: 1.5,
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
                        style: const TextStyle(
                          color: AppTheme.starWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Show connection count indicator
                    if (hasLinkedNotes)
                      Text(
                        '${widget.note.linkedNoteIds.length}',
                        style: const TextStyle(
                          color: AppTheme.starWhite,
                          fontSize: 8,
                        ),
                      ),
                  ],
                ),
              ),
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
