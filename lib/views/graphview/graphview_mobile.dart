// ignore_for_file: prefer_final_fields

part of graphview_view;

class _GraphViewMobile extends StatefulWidget {
   final List<ZettelNote> notes;
  const _GraphViewMobile({required this.notes, Key? key}) : super(key: key);

  @override
  State<_GraphViewMobile> createState() => _GraphViewMobileState();
}

class _GraphViewMobileState extends State<_GraphViewMobile> with SingleTickerProviderStateMixin{
  final Graph _graph = Graph();
  late FruchtermanReingoldAlgorithm builder;
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

    for(var note in widget.notes){
      final sourceNode = nodeMap[note.id];
      if(sourceNode == null) return;
      for(var linkedId in note.linkedNoteIds){
        final targetNode = nodeMap[linkedId];
        if(targetNode != null){
          if(!_graph.edges.any((edge) => 
          (edge.source == sourceNode && edge.destination == targetNode) ||
          (edge.source == targetNode && edge.destination == sourceNode )
          )){     
            _graph.addEdge(sourceNode, targetNode);
          }
        }
      }
    }
    builder = FruchtermanReingoldAlgorithm(iterations: 1000);
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
    return Stack(
      children: [
        // Starry background
        FadeTransition(
          opacity: _fadeanimation,
          child: Positioned.fill(
            child: CustomPaint(
              painter: StarryBackgroundPainter(),
            ),
          ),
        ),
        SlideTransition(
          position: _scaleanimation,
          child: InteractiveViewer(
            boundaryMargin:const EdgeInsets.all(100),
            minScale: 0.01,
            maxScale: 5.0,
            child: GraphView(
              graph: _graph,
              algorithm: builder,
              builder: (Node node) {
                // node.key = GlobalKey() if needed
                return node.data!;
              },
            ),
          ),
        ),
        SlideTransition(
          position: _scaleanimation,
          child: Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _createNote,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    // Draw random stars
    final random = RandomColor();
    for (int i = 0; i < 100; i++) {
      final dx = (size.width) * (Random.secure().nextDouble());
      final dy = (size.height) * (Random.secure().nextDouble());
      canvas.drawCircle(Offset(dx, dy), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}