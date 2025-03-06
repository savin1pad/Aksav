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
  final Graph _graph = Graph()..isTree = false;
  late FruchtermanReingoldAlgorithm builder;
  late AnimationController _controller;
  late Animation<double> _fadeanimation;
  late Animation<Offset> _scaleanimation;
  String? _selectedNoteId;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<ZettelNote> _filteredNotes = [];
  List<ZettelFolder> _folders = [];
  bool _isLoadingFolders = false;
  String? _currentFolderId;
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Add at the top of _GraphViewMobileState class
  final ZoomDrawerController _drawerController = ZoomDrawerController();

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

  final customEdgeRenderer = SafeArrowEdgeRenderer();
  
  builder = FruchtermanReingoldAlgorithm(
    iterations: 300,         // Reduced iterations to prevent algorithm instability
    repulsionRate: 0.8,      // Slightly lower than 1.0 to prevent oscillation
    attractionRate: 0.05,    
    repulsionPercentage: 0.6, 
    renderer: customEdgeRenderer // Use our custom renderer
  );
  
  // Delay building the graph until the widget has been laid out
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _buildGraph();
  });
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
  final random = math.Random();

  // Safety check - if there are no notes, just return
  if (widget.notes.isEmpty) {
    setState(() {});
    return;
  }

  try {
    // Get the available screen area
    final screenSize = MediaQuery.of(context).size;
    double graphAreaWidth = screenSize.width * 0.8;
    double graphAreaHeight = screenSize.height * 0.8;
    
    // Use a fixed minimum size for small screens
    graphAreaWidth = math.max(graphAreaWidth, 300);
    graphAreaHeight = math.max(graphAreaHeight, 300);
    
    // Create nodes with a circular layout initially
    final int nodeCount = widget.notes.length;
    final double radius = math.min(graphAreaWidth, graphAreaHeight) / 3;
    final double centerX = graphAreaWidth / 2;
    final double centerY = graphAreaHeight / 2;
    
    for (int i = 0; i < widget.notes.length; i++) {
      final note = widget.notes[i];
      
      // Create a circular layout
      final double angle = (i / nodeCount) * 2 * math.pi;
      double x = centerX + radius * math.cos(angle);
      double y = centerY + radius * math.sin(angle);
      
      // Add some randomness to prevent exact overlapping
      x += (random.nextDouble() - 0.5) * (radius * 0.2);
      y += (random.nextDouble() - 0.5) * (radius * 0.2);
      
      // Ensure no NaN or infinity values
      if (!x.isFinite) x = centerX;
      if (!y.isFinite) y = centerY;
      
      final node = Node(_buildNoteNode(note));
      node.position = Offset(x, y);
      
      nodeMap[note.id] = node;
      _graph.addNode(node);
    }

    // Add edges
    for (var note in widget.notes) {
      final sourceNode = nodeMap[note.id];
      if (sourceNode == null) continue;
      
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
    
    // Adjust dimensions for the algorithm
    builder.setDimensions(graphAreaWidth, graphAreaHeight);
    
    // Run the algorithm with gentle iterations
    for (int i = 0; i < 3; i++) {
      builder.step(_graph);
      // Validate positions after each step
      _validateAllNodePositions(_graph, graphAreaWidth, graphAreaHeight);
    }
    
  } catch (e) {
    log("Error building graph: $e");
    // Use circular layout as fallback
    _applyCircularLayout(_graph, MediaQuery.of(context).size);
  }
  
  setState(() {});
}

// Add this helper method to validate and fix all node positions
void _validateAllNodePositions(Graph graph, double width, double height) {
  const padding = 10.0;
  for (var node in graph.nodes) {
    // Check for invalid positions
    if (!node.x.isFinite || !node.y.isFinite) {
      // Assign a valid position within bounds
      node.position = Offset(
        math.Random().nextDouble() * (width - 2 * padding) + padding,
        math.Random().nextDouble() * (height - 2 * padding) + padding
      );
    }
    
    // Ensure positions are within bounds
    node.position = Offset(
      node.x.clamp(padding, width - padding),
      node.y.clamp(padding, height - padding)
    );
  }
}

// Simplified circular layout as a reliable fallback
void _applyCircularLayout(Graph graph, Size screenSize) {
  const padding = 50.0;
  final availableWidth = screenSize.width - padding * 2;
  final availableHeight = screenSize.height - padding * 2;
  
  final nodeCount = graph.nodes.length;
  if (nodeCount == 0) return;
  
  final radius = math.min(availableWidth, availableHeight) / 3;
  final centerX = availableWidth / 2;
  final centerY = availableHeight / 2;
  
  for (int i = 0; i < nodeCount; i++) {
    final angle = (i / nodeCount) * 2 * math.pi;
    final x = centerX + radius * math.cos(angle);
    final y = centerY + radius * math.sin(angle);
    
    graph.nodes[i].position = Offset(
      x + padding,
      y + padding
    );
  }
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
    return GraphZoomDrawer(
    notes: widget.notes,
    folders: _folders,
    isLoadingFolders: _isLoadingFolders,
    isSearching: _isSearching,
    filteredNotes: _filteredNotes,
    currentFolderId: _currentFolderId,
    searchController: _searchController,
    onAllNotesTap: () {
      setState(() {
        _currentFolderId = null;
      });
      _drawerController.close?.call();
    },
    onFolderTap: (folderId) {
      setState(() {
        _currentFolderId = folderId;
      });
      _drawerController.close?.call();
    },
    onCreateFolder: () {
      // Add folder creation logic
    },
    onClearSearch: () {
      setState(() {
        _searchController.clear();
        _isSearching = false;
        _filteredNotes = [];
      });
    },
    onSearchChanged: (value) {
      setState(() {
        _isSearching = value.isNotEmpty;
        _filteredNotes = widget.notes
            .where((note) =>
                note.title.toLowerCase().contains(value.toLowerCase()) ||
                note.content.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    },
    onSettingsTap: () {
      // Add settings navigation
    },
    onHelpTap: () {
      // Add help navigation
    },
    onInfoTap: () {
      // Add info navigation
    },
    zoomDrawerController: _drawerController,
    mainScreen: _buildMainScreen(context),
  );
  }

  PopScope<dynamic> _buildMainScreen(BuildContext context) {
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
                  IconButton(
                  icon: const Icon(Icons.menu, color: AppTheme.starWhite),
                  onPressed: () {
                    _drawerController.toggle!();
                   },
                  ),
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



class SafeArrowEdgeRenderer extends ArrowEdgeRenderer {
  @override
  void render(Canvas canvas, Graph graph, Paint paint) {
    // First validate all node positions
    for (var node in graph.nodes) {
      if (node.x.isNaN || node.y.isNaN) {
        // Fix invalid positions
        node.position =const Offset(0, 0);
      }
    }
    
    // Now draw edges only between nodes with valid positions
    for (var edge in graph.edges) {
      if (edge.source.x.isFinite && edge.source.y.isFinite &&
          edge.destination.x.isFinite && edge.destination.y.isFinite) {
        // Draw lines only for valid positions
        canvas.drawLine(
          Offset(edge.source.x, edge.source.y),
          Offset(edge.destination.x, edge.destination.y),
          edge.paint ?? paint,
        );
      }
    }
  }
}