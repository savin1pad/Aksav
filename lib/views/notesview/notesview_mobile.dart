// ignore_for_file: use_build_context_synchronously

part of notesview_view;

class _NotesViewMobile extends StatefulWidget {
  final ZettelNote note;
  const _NotesViewMobile({Key? key, required this.note}) : super(key: key);

  @override
  State<_NotesViewMobile> createState() => _NotesViewMobileState();
}

class _NotesViewMobileState extends State<_NotesViewMobile> {
  List<ZettelNote> linkedNotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinkedNotes();
  }

    Future<void> _loadLinkedNotes() async {
    if (widget.note.linkedNoteIds.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final repository = app<ZettelRepository>();
      final List<ZettelNote> loadedNotes = [];
      
      for (final id in widget.note.linkedNoteIds) {
        try {
          final note = await repository.getZettelById(id);
          loadedNotes.add(note);
        } catch (e) {
          // Log the error but continue loading other notes
          debugPrint('Failed to load linked note with ID: $id - $e');
        }
      }
      
      if (mounted) {
        setState(() {
          linkedNotes = loadedNotes;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading linked notes: ${e.toString()}'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }
  
  void _editNote() async {
    final result = await Navigator.push<ZettelNote?>(
      context,
      CustomPageRoute(
        child: NoteseditscreenMobile(existingNote: widget.note),
      ),
    );
    
    if (result != null) {
      Navigator.pop(context, result); // Return to previous screen with updated note
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final createdDate = DateTime.tryParse(widget.note.id.substring(0, 8)) ?? 
                        DateTime.now();
                        
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.starWhite),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.starWhite),
            onPressed: _editNote,
          ),
        ],
      ),
      body: SpaceBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title section with cosmic-themed styling
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.nebulaPurple.withOpacity(0.7),
                          AppTheme.deepSpace.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: AppTheme.starWhite.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.note.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.starWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, 
                                size: 14, color: AppTheme.starWhite),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(createdDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.starWhite.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Image carousel if there are images
                  if (widget.note.imageUrls.isNotEmpty)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PageView.builder(
                          itemCount: widget.note.imageUrls.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Show full-screen image view
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      backgroundColor: Colors.black,
                                      body: Center(
                                        child: InteractiveViewer(
                                          child: Image.file(
                                            widget.note.imageUrls[index],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      appBar: AppBar(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: '${widget.note.id}_image_$index',
                                child: Image.file(
                                  widget.note.imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  
                  // Content section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.deepSpace.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.starWhite.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      widget.note.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.starWhite,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Linked notes section
                  if (widget.note.linkedNoteIds.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.link, color: AppTheme.starWhite),
                            const SizedBox(width: 8),
                            Text(
                              'Linked Notes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.starWhite,
                                shadows: [
                                  Shadow(
                                    color: AppTheme.nebulaPurple.withOpacity(0.5),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.nebulaPurple,
                            ),
                          )
                        else if (linkedNotes.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.deepSpace.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.nebulaPurple.withOpacity(0.3),
                              ),
                            ),
                            child: const Text(
                              'The linked notes could not be loaded.',
                              style: TextStyle(
                                color: AppTheme.starWhite,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: linkedNotes.length,
                            itemBuilder: (context, index) {
                              final linkedNote = linkedNotes[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CustomPageRoute(
                                      child: NotesView(zettelNote: linkedNote),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.nebulaPurple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.nebulaPurple.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.nebulaPurple,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.note,
                                            color: AppTheme.starWhite,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              linkedNote.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.starWhite,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              linkedNote.content.length > 60
                                                  ? '${linkedNote.content.substring(0, 60)}...'
                                                  : linkedNote.content,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.starWhite.withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppTheme.starWhite,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
