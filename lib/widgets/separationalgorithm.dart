import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class SeparationAwareAlgorithm extends FruchtermanReingoldAlgorithm {
  /// Map of targetNodeId to list of source nodes that connect to it
  final Map<String, List<Node>> _linkedNodesMap = {};
  
  /// Map of node IDs to nodes for quick lookup
  final Map<String, Node> _nodeIdMap = {};
  
  /// The minimum distance to enforce between linked nodes
  final double minSeparationDistance;
  
  SeparationAwareAlgorithm({
    int iterations = 300,
    EdgeRenderer? renderer,
    double repulsionRate = 0.8,
    double attractionRate = 0.05,
    double repulsionPercentage = 0.6,
    double attractionPercentage = 0.15,
    this.minSeparationDistance = 60.0,
  }) : super(
          iterations: iterations,
          renderer: renderer,
          repulsionRate: repulsionRate,
          attractionRate: attractionRate,
          repulsionPercentage: repulsionPercentage,
          attractionPercentage: attractionPercentage,
        );
  
  /// Register nodes by their relationship data
  void registerNodeData(Map<String, List<Node>> linkedNodesMap, Map<String, Node> nodeMap) {
    _linkedNodesMap.clear();
    _linkedNodesMap.addAll(linkedNodesMap);
    
    _nodeIdMap.clear();
    _nodeIdMap.addAll(nodeMap);
  }
  
  @override
  void step(Graph? graph) {
    // First do the standard force-directed algorithm step
    super.step(graph);
    
    // Then enforce node separation
    enforceNodeSeparation();
  }
  
  void enforceNodeSeparation() {
    _linkedNodesMap.forEach((targetId, sourceNodes) {
      if (sourceNodes.length > 1) {
        final targetNode = _nodeIdMap[targetId];
        if (targetNode == null) return;
        
        // Calculate a good orbit radius based on node count
        final nodeCount = sourceNodes.length;
        final orbitRadius = math.max(minSeparationDistance, minSeparationDistance * (1 + math.log(nodeCount) / 5));
        
        for (int i = 0; i < sourceNodes.length; i++) {
          final sourceNode = sourceNodes[i];
          
          // Calculate position in a circle around the target
          final angle = (i / sourceNodes.length) * 2 * math.pi;
          final offsetX = orbitRadius * math.cos(angle);
          final offsetY = orbitRadius * math.sin(angle);
          
          // Set explicit position to avoid overlap
          sourceNode.position = Offset(
            targetNode.x + offsetX,
            targetNode.y + offsetY
          );
        }
      }
    });
  }
  
  @override
  Size run(Graph? graph, double shiftX, double shiftY) {
    // Run standard algorithm first
    final result = super.run(graph, shiftX, shiftY);
    
    // Final enforcement of separation before returning
    enforceNodeSeparation();
    
    return result;
  }
}