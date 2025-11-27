import 'package:flutter/material.dart';
import 'dart:math' as math;

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Mock data for calls
  final List<Map<String, dynamic>> _mockCalls = [
    {
      'name': 'John Doe',
      'time': '10 minutes ago',
      'type': 'incoming',
      'isVideo': false,
      'isMissed': false,
    },
    {
      'name': 'Sarah Smith',
      'time': '1 hour ago',
      'type': 'outgoing',
      'isVideo': true,
      'isMissed': false,
    },
    {
      'name': 'Mike Johnson',
      'time': 'Yesterday',
      'type': 'incoming',
      'isVideo': false,
      'isMissed': true,
    },
    {
      'name': 'Emma Wilson',
      'time': 'Yesterday',
      'type': 'outgoing',
      'isVideo': true,
      'isMissed': false,
    },
    {
      'name': 'Alex Brown',
      'time': '2 days ago',
      'type': 'incoming',
      'isVideo': false,
      'isMissed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_mockCalls.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _mockCalls.length,
      itemBuilder: (context, index) {
        return _buildAnimatedCallItem(context, _mockCalls[index], index);
      },
    );
  }

  Widget _buildAnimatedCallItem(
    BuildContext context,
    Map<String, dynamic> call,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.easeOut.transform(
          ((_controller.value - (index * 0.1)).clamp(0.0, 1.0)),
        );

        return Transform.translate(
          offset: Offset(0, 30 * (1 - progress)),
          child: Opacity(
            opacity: progress.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: _buildCallItem(call),
    );
  }

  Widget _buildCallItem(Map<String, dynamic> call) {
    final isMissed = call['isMissed'] as bool;
    final isVideo = call['isVideo'] as bool;
    final type = call['type'] as String;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              color: Colors.grey[600],
              size: 28,
            ),
          ),
          if (isVideo)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.videocam,
                  size: 14,
                  color: Colors.green[700],
                ),
              ),
            ),
        ],
      ),
      title: Text(
        call['name'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isMissed ? Colors.red : Colors.black87,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            type == 'incoming'
                ? Icons.call_received
                : Icons.call_made,
            size: 16,
            color: isMissed ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            call['time'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          isVideo ? Icons.videocam : Icons.call,
          color: Colors.green[700],
        ),
        onPressed: () {
          _showCallDialog(context, call['name'], isVideo);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _controller,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticOut,
                ),
              ),
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[50],
                ),
                child: Icon(
                  Icons.phone_outlined,
                  size: 80,
                  color: Colors.green[400],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No calls yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Make your first call to see it here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context, String name, bool isVideo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              isVideo ? Icons.videocam : Icons.call,
              color: Colors.green[700],
            ),
            const SizedBox(width: 12),
            Text('Call $name'),
          ],
        ),
        content: Text(
          'Start a ${isVideo ? 'video' : 'voice'} call with $name?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $name...'),
                  backgroundColor: Colors.green[700],
                ),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }
}