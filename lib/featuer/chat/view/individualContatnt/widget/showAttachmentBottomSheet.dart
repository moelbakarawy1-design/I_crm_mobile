import 'package:flutter/material.dart';

/// Show Animated Attachment Bottom Sheet
void showAttachmentBottomSheet({
  required BuildContext context,
  required VoidCallback onImagePick,
  required VoidCallback onVideoPick,
  required VoidCallback onDocumentPick,
  required VoidCallback onLocationPick,
  required VoidCallback onContactPick,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => AttachmentBottomSheet(
      onImagePick: onImagePick,
      onVideoPick: onVideoPick,
      onDocumentPick: onDocumentPick,
      onLocationPick: onLocationPick,
      onContactPick: onContactPick,
    ),
  );
}

class AttachmentBottomSheet extends StatefulWidget {
  final VoidCallback onImagePick;
  final VoidCallback onVideoPick;
  final VoidCallback onDocumentPick;
  final VoidCallback onLocationPick;
  final VoidCallback onContactPick;

  const AttachmentBottomSheet({
    super.key,
    required this.onImagePick,
    required this.onVideoPick,
    required this.onDocumentPick,
    required this.onLocationPick,
    required this.onContactPick,
  });

  @override
  State<AttachmentBottomSheet> createState() => _AttachmentBottomSheetState();
}

class _AttachmentBottomSheetState extends State<AttachmentBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Staggered animations for each item
    _itemAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.5 + (index * 0.1),
            curve: Curves.easeOut, // Changed from easeOutBack to prevent > 1.0
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      AttachmentOption(
        icon: Icons.image,
        color: Colors.purple,
        label: "Gallery",
        onTap: widget.onImagePick,
      ),
      AttachmentOption(
        icon: Icons.videocam,
        color: Colors.pink,
        label: "Video",
        onTap: widget.onVideoPick,
      ),
      AttachmentOption(
        icon: Icons.insert_drive_file,
        color: Colors.blue,
        label: "Document",
        onTap: widget.onDocumentPick,
      ),
      AttachmentOption(
        icon: Icons.location_on,
        color: Colors.green,
        label: "Location",
        onTap: widget.onLocationPick,
      ),
      AttachmentOption(
        icon: Icons.person,
        color: Colors.blueAccent,
        label: "Contact",
        onTap: widget.onContactPick,
      ),
    ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle Bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'Share Content',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Options Grid
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    runSpacing: 20,
                    spacing: 20,
                    children: List.generate(options.length, (index) {
                      return AnimatedOptionItem(
                        option: options[index],
                        animation: _itemAnimations[index],
                        onTap: () {
                          Navigator.pop(context);
                          options[index].onTap();
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AttachmentOption {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  AttachmentOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}

class AnimatedOptionItem extends StatefulWidget {
  final AttachmentOption option;
  final Animation<double> animation;
  final VoidCallback onTap;

  const AnimatedOptionItem({
    super.key,
    required this.option,
    required this.animation,
    required this.onTap,
  });

  @override
  State<AnimatedOptionItem> createState() => _AnimatedOptionItemState();
}

class _AnimatedOptionItemState extends State<AnimatedOptionItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        // Clamp values to prevent errors
        final scale = (widget.animation.value * (_isPressed ? 0.9 : 1.0)).clamp(0.0, 1.0);
        final opacity = widget.animation.value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onTap,
              child: SizedBox(
                width: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Container with Animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.option.color.withOpacity(0.15),
                        boxShadow: _isPressed
                            ? []
                            : [
                                BoxShadow(
                                  color: widget.option.color.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        widget.option.icon,
                        color: widget.option.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Label
                    Text(
                      widget.option.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}