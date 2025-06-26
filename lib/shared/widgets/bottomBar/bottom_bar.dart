import 'package:app_m0v4u/constants/styles.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppBottomBar extends StatefulWidget {
  final List<String> icons;
  final int defaultSelectedIndex;
  final ValueChanged<int>? onItemClicked;

  const AppBottomBar({
    super.key,
    required this.icons,
    this.defaultSelectedIndex = 0,
    this.onItemClicked,
  });

  @override
  AppBottomBarState createState() => AppBottomBarState();
}

class AppBottomBarState extends State<AppBottomBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.defaultSelectedIndex;
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateIndex(int index, [bool isInit = false]) {
    if (index == _selectedIndex && !isInit) return;
    if (widget.onItemClicked != null) {
      widget.onItemClicked!(index);
    }
    setState(() {
      _selectedIndex = index;
    });
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: AppStyles.secondaryColor.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(
          widget.icons.length,
          (index) {
            return Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (_, __) {
                  return Transform.translate(
                    offset: _selectedIndex == index ? Offset(0, -_animation.value * 22) : Offset.zero,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _updateIndex(index),
                      child: AnimatedContainer(
                        padding: _selectedIndex == index ? EdgeInsets.all(16) : null,
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: _selectedIndex == index
                                ? [
                                    AppStyles.primaryColor,
                                    AppStyles.secondaryColor,
                                  ]
                                : [
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                          ),
                        ),
                        child: Image.asset(
                          widget.icons[index],
                          width: _selectedIndex == index ? 30 : 27,
                          height: _selectedIndex == index ? 30 : 27,
                          color: _selectedIndex == index ? AppStyles.secondaryColor : AppStyles.textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
