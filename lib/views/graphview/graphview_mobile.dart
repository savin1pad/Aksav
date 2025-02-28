// ignore_for_file: prefer_final_fields, unused_local_variable

part of graphview_view;

class _GraphViewMobile extends StatefulWidget {
  final List<ZettelNote> notes;
  const _GraphViewMobile({required this.notes, Key? key}) : super(key: key);

  @override
  State<_GraphViewMobile> createState() => _GraphViewMobileState();
}

class _GraphViewMobileState extends State<_GraphViewMobile>
    with SingleTickerProviderStateMixin {
  final Graph _graph = Graph();
  late FruchtermanReingoldAlgorithm builder;
  late AnimationController _controller;
  late Animation<double> _fadeanimation;
  late Animation<Offset> _scaleanimation;
  String? _selectedNoteId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeanimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    _scaleanimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
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

    for (var note in widget.notes) {
      final sourceNode = nodeMap[note.id];
      if (sourceNode == null) return;
      for (var linkedId in note.linkedNoteIds) {
        final targetNode = nodeMap[linkedId];
        if (targetNode != null) {
          if (!_graph.edges.any((edge) =>
              (edge.source == sourceNode && edge.destination == targetNode) ||
              (edge.source == targetNode && edge.destination == sourceNode))) {
            _graph.addEdge(
              sourceNode,
              targetNode,
              paint: Paint()
                ..color = AppTheme.starWhite
                ..strokeWidth = 1.5
                ..strokeCap = StrokeCap.round,
            );
          }
        }
      }
    }
    builder = FruchtermanReingoldAlgorithm(iterations: 1000);
  }

  Widget _buildNoteNode(ZettelNote note) {
    return NoteNodeWidget(
      note: note,
      isSelected: note.id == _selectedNoteId,
      onTap: () {
        setState(() {
          _selectedNoteId = note.id;
        });
        _openDetail(note);
      },
    );
  }

  void _openDetail(ZettelNote note) {
    Navigator.push(
      context,
      CustomPageRoute(child: NotesView(zettelNote: note)),
    ).then((_) {
      setState(() {
        _selectedNoteId = null;
      });
    });
  }

  Future<void> _createNote() async {
    final result = await Navigator.push<ZettelNote?>(
      context,
      CustomPageRoute(child: const NoteseditscreenMobile()),
    );
    if (result != null) {
      setState(() {});
    }
  }

  Widget containerboiler(dynamic a) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        a.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SpaceBackground(
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeanimation,
                    child: SlideTransition(
                      position: _scaleanimation,
                      child: InteractiveViewer(
                        boundaryMargin: const EdgeInsets.all(100),
                        minScale: 0.1,
                        maxScale: 2.5,
                        child: GraphView(
                          graph: _graph,
                          algorithm: builder,
                          paint: Paint()
                            ..color = AppTheme.starWhite.withOpacity(0.6)
                            ..strokeWidth = 1.5
                            ..strokeCap = StrokeCap.round,
                          builder: (node) {
                            return node.key!.value;
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.deepSpace,
                    AppTheme.deepSpace.withOpacity(0.0),
                  ],
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cosmic Knowledge Map',
                      style: AppTheme.headerStyle.copyWith(fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline,
                          color: AppTheme.starWhite),
                      onPressed: () {
                        // Show help/info about the graph view
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Explore your interconnected knowledge universe')));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _createNote,
                backgroundColor: AppTheme.nebulaPurple,
                elevation: 4,
                child: const Icon(
                  Icons.add,
                  color: AppTheme.starWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);

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
