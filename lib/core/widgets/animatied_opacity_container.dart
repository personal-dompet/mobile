import 'package:flutter/material.dart';

class AnimatedOpacityContainer extends StatefulWidget {
  final bool isAnimated;
  final Widget child;
  const AnimatedOpacityContainer({
    super.key,
    required this.isAnimated,
    required this.child,
  });

  @override
  State<AnimatedOpacityContainer> createState() =>
      _AnimatedOpacityContainerState();
}

class _AnimatedOpacityContainerState extends State<AnimatedOpacityContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Only animate if item.id equals -1 (new item)
    if (widget.isAnimated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedOpacityContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isAnimated != widget.isAnimated) {
      if (widget.isAnimated) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimated) return widget.child;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
