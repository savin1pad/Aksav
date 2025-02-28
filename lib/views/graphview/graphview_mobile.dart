// ignore_for_file: prefer_final_fields

part of graphview_view;

class _GraphViewMobile extends StatefulWidget {
   final List<ZettelNote> notes;
  const _GraphViewMobile({required this.notes});

  @override
  State<_GraphViewMobile> createState() => _GraphViewMobileState();
}

class _GraphViewMobileState extends State<_GraphViewMobile> with SingleTickerProviderStateMixin{
  final Graph _graph = Graph();
  BuchheimWalkerConfiguration _builder = BuchheimWalkerConfiguration();
  late AnimationController _controller;
  late Animation<double> _fadeanimation;
  late Animation<Offset> _scaleanimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeanimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    _scaleanimation = Tween<Offset>(begin:const Offset(-1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    _controller.forward();
    _buildGraph();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _GraphViewMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notes != widget.notes) {
      _buildGraph();
    }
  }

  void _buildGraph() {
    _graph.nodes.clear();
    _graph.edges.clear();

    final nodeMap = <String, Node>{};

    for (final note in widget.notes) {
      final node = Node(_buildNoteNode(note));
      nodeMap[note.id] = node;
      _graph.addNode(node);
    }
    // A simple approach: link each noe to the next so we can see some edges
    // or parse note.linkedNoteIds, etc. Adapt to your logic
    final sorted = widget.notes.toList()
      ..sort((a, b) => a.content.compareTo(b.content));
    for (int i = 0; i < sorted.length - 1; i++) {
      _graph.addEdge(nodeMap[sorted[i].id]!, nodeMap[sorted[i + 1].id]!);
    }

    _builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
  }

  Widget _buildNoteNode(ZettelNote note) {
    return GestureDetector(
      onTap: () => _openDetail(note),
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.imageUrls.isNotEmpty)
              Hero(
                tag: '${note.id}_image_0',
                child: Image.file(
                  note.imageUrls.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                color: Colors.grey.shade300,
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported),
              ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                note.title,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(ZettelNote note) {
    Navigator.push(
      context,
      CustomPageRoute(child: NotesView(zettelNote: note)),
    );
  }

  Future<void> _createNote() async {
    final result = await Navigator.push<ZettelNote?>(
      context,
      CustomPageRoute(child: const NoteseditscreenMobile()),
    );
    if (result != null) {
      // We rely on the real-time stream to refresh the UI, so no need to do anything else here
    }
  }

  Widget containerboiler(dynamic a){
    return Container(
      width:100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Text(a.toString(),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zettelkasten Brain (RTDB)'),
      ),
      drawer: Drawer(
        child: FadeTransition(
          opacity: _fadeanimation,
          child: SlideTransition(
            position: _scaleanimation,
            child: ListView(
              children:  [
               SlideTransition(
                position: _scaleanimation,
                 child: const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                    ),
                    child:  Center(
                      child: Text(
                        'Notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
               ),
                ListTile(
                  title: const Text('Notes'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Graph View'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body:widget.notes.isEmpty ? Center(child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient:const LinearGradient(colors: [
            Colors.purpleAccent,
            Colors.purple,
             ],
           stops:  [0.0, 0.7],  
            ),
          border: Border.all(color: Colors.black),
        ),
        child:const Center(
          child: Text('No Notes Found', style: TextStyle(color: Colors.white,
           ),
          ),
        ),
       ),
      ): InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(100),
        constrained: false,
        minScale: 0.01,
        maxScale: 5.0,
        child: GraphView(
          graph: _graph,
          algorithm: BuchheimWalkerAlgorithm(_builder, TreeEdgeRenderer(_builder)),
          paint: Paint()
            ..color = Colors.grey
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
            builder: (node){
              var a = node.key?.value as dynamic;
              return containerboiler(a);
            },
         ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}