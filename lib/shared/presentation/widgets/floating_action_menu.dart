// lib/shared/presentation/widgets/floating_action_menu.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FloatingActionMenuItem {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  FloatingActionMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}

class FloatingActionMenu extends StatefulWidget {
  final List<FloatingActionMenuItem> items;
  final IconData mainIcon;
  final Color? mainColor;
  final bool isOpen;
  final VoidCallback onToggle;

  const FloatingActionMenu({
    super.key,
    required this.items,
    required this.onToggle,
    this.mainIcon = Icons.add,
    this.mainColor,
    this.isOpen = false,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimations = List.generate(
      widget.items.length,
      (index) => Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset(0, -(index + 1) * 1.2),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          1.0,
          curve: Curves.elasticOut,
        ),
      )),
    );
  }

  @override
  void didUpdateWidget(FloatingActionMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
        _rotationController.forward();
      } else {
        _controller.reverse();
        _rotationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Color get _mainColor => widget.mainColor ?? AppColors.electricBlue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Background overlay
        if (widget.isOpen)
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        
        // Menu items
        ...widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: _slideAnimations[index].value * 70,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildMenuItem(item),
                ),
              );
            },
          );
        }).toList(),
        
        // Main FAB
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: FloatingActionButton(
                onPressed: widget.onToggle,
                backgroundColor: _mainColor,
                elevation: 8,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _mainColor,
                        _mainColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _mainColor.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isOpen ? Icons.close : widget.mainIcon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(FloatingActionMenuItem item) {
    final itemColor = item.color ?? AppColors.neonGreen;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: itemColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            item.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Icon button
        GestureDetector(
          onTap: () {
            item.onTap();
            widget.onToggle();
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  itemColor,
                  itemColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: itemColor.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}