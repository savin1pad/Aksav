part of notesview_view;

class _NotesViewMobile extends StatelessWidget {
  final ZettelNote note;
  const _NotesViewMobile({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: note.imageUrls.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final url = note.imageUrls[index];
                    return Hero(
                      tag: '${note.id}_image_$index',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
            const SizedBox(height: 16),
            Text(note.content),
            const SizedBox(height: 16),
            Text(
              'Created: ${note.id}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Updated: ${note.id}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
