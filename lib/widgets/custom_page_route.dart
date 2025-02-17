// lib/widgets/custom_page_route.dart
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  CustomPageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Slide from bottom & fade
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOut),
    );
    final offsetAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: offsetAnim,
        child: child,
      ),
    );
  }
}