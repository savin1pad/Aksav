import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:journey/widgets/apptheme.dart';
import 'package:journey/widgets/nodewidget.dart';

class ConstellationEffectPainter extends CustomPainter {
  final Graph graph;
  final Map<String, List<String>> highlightedConnections;
  
  ConstellationEffectPainter({
    required this.graph,
    required this.highlightedConnections,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final nodes = graph.nodes;
    final random = Random(12345); // Fixed seed for consistency
    
    // Draw highlighted connections
    for (final sourceId in highlightedConnections.keys) {
      // Find source node
      final sourceNode = nodes.firstWhere(
        (node) {
          final widget = node.key?.value as NoteNodeWidget?;
          return widget?.note.id == sourceId;
        },
        orElse: () => Node(Container()),
      );
      
      // Get target nodes
      for (final targetId in highlightedConnections[sourceId] ?? []) {
        final targetNode = nodes.firstWhere(
          (node) {
            final widget = node.key?.value as NoteNodeWidget?;
            return widget?.note.id == targetId;
          },
          orElse: () => Node(Container()),
        );
        
        // Draw cosmic connection
        _drawGlowingLine(canvas, sourceNode.position, targetNode.position);
        _drawStarParticles(canvas, sourceNode.position, targetNode.position, random);
      }
    }
  }
  
  void _drawGlowingLine(Canvas canvas, Offset start, Offset end) {
    const width = 2.0;
    const Color edgeColor = AppTheme.cosmicBlue;
    
    // Paint main line
    final highlightPaint = Paint()
      ..color = edgeColor
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(start, end, highlightPaint);
    
    // Add glow effect with multiple transparent lines
    for (double i = 1; i <= 3; i++) {
      final glowPaint = Paint()
        ..color = edgeColor.withOpacity(0.3 / i)
        ..strokeWidth = width + (i * 3)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(start, end, glowPaint);
    }
  }
  
  void _drawStarParticles(Canvas canvas, Offset start, Offset end, Random random) {
    final distance = (end - start).distance;
    final particleCount = (distance / 50).round().clamp(3, 8);
    
    for (int i = 0; i < particleCount; i++) {
      // Random position along the line
      final progress = random.nextDouble();
      final position = Offset(
        start.dx + (end.dx - start.dx) * progress,
        start.dy + (end.dy - start.dy) * progress,
      );
      
      // Random size for variety
      final size = 1.5 + random.nextDouble() * 2;
      
      // Draw star particle
      final starPaint = Paint()
        ..color = AppTheme.starWhite
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, size, starPaint);
      
      // Add glow around star
      final glowPaint = Paint()
        ..color = AppTheme.starWhite.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, size * 1.5, glowPaint);
    }
  }
  
  @override
  bool shouldRepaint(ConstellationEffectPainter oldDelegate) => true;
}