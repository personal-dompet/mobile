import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;
  final Duration pauseDuration;
  final double blankSpace;

  const AutoScrollText({
    super.key,
    required this.text,
    this.style,
    this.velocity = 30.0,
    this.pauseDuration = const Duration(seconds: 1),
    this.blankSpace = 40.0,
  });

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOverflowing = false;
  double _textWidth = 0;
  // double _containerWidth = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  @override
  void didUpdateWidget(AutoScrollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _animationController.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkOverflow();
      });
    }
  }

  void _checkOverflow() {
    if (!mounted) return;

    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final containerWidth = renderBox.size.width;
    final textWidth = textPainter.width;
    final isOverflowing = textWidth > containerWidth;

    setState(() {
      _isOverflowing = isOverflowing;
      _textWidth = textWidth;
      // _containerWidth = containerWidth;
    });

    if (isOverflowing) {
      _startScrolling();
    }
  }

  void _startScrolling() {
    final totalDistance = _textWidth + widget.blankSpace;

    final duration = Duration(
      milliseconds: ((totalDistance / widget.velocity) * 1000).round(),
    );

    _animationController.duration = duration;

    _animation = Tween<double>(begin: 0.0, end: -totalDistance).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animateWithPause();
  }

  Future<void> _animateWithPause() async {
    if (!mounted) return;

    while (mounted && _isOverflowing) {
      await Future.delayed(widget.pauseDuration);

      if (!mounted || !_isOverflowing) break;

      await _animationController.forward(from: 0.0);

      if (!mounted || !_isOverflowing) break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOverflowing) {
      return Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: widget.style,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(width: widget.blankSpace),
                Text(
                  widget.text,
                  style: widget.style,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
