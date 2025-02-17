part of notesview_view;

class _NotesViewDesktop extends StatelessWidget {
  const _NotesViewDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: const Center(
        child: Text('NotesViewDesktop'),
      ),
    );
  }
}
