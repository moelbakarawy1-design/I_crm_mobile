import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';

/// Helper class for grouping messages visually
class MessageGroupingHelper {
  static const Duration _groupThreshold = Duration(seconds: 3);

  /// Generate a unique group ID based on timestamp
  static String generateGroupId() {
    return 'GRP_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Check if two messages should be grouped together
  static bool shouldGroup(OrderedMessages msg1, OrderedMessages msg2) {
    // Must be from same sender
    if (msg1.from != msg2.from) return false;

    // Both must be media (image or video)
    final validTypes = ['image', 'video'];
    if (!validTypes.contains(msg1.type) || !validTypes.contains(msg2.type)) {
      return false;
    }

    // Check timestamp proximity
    try {
      final time1 = DateTime.parse(msg1.createdAt ?? '');
      final time2 = DateTime.parse(msg2.createdAt ?? '');

      return time2.difference(time1).abs() < _groupThreshold;
    } catch (e) {
      return false;
    }
  }

  /// Group consecutive image/video messages
  static List<MessageGroup> groupMessages(List<OrderedMessages> messages) {
    final List<MessageGroup> groups = [];

    if (messages.isEmpty) return groups;

    MessageGroup? currentGroup;

    for (var message in messages) {
      if (message.type == 'image' || message.type == 'video') {
        // Check if we should add to current group
        if (currentGroup != null &&
            currentGroup.messages.isNotEmpty &&
            shouldGroup(currentGroup.messages.last, message) &&
            currentGroup.messages.last.type == message.type) {
          // Same media type
          currentGroup.messages.add(message);
        } else {
          // Start new group
          if (currentGroup != null) {
            groups.add(currentGroup);
          }
          currentGroup = MessageGroup(
            messages: [message],
            isImageGroup: message.type == 'image',
            isVideoGroup: message.type == 'video',
          );
        }
      } else {
        // Non-media message, close current group
        if (currentGroup != null) {
          groups.add(currentGroup);
          currentGroup = null;
        }
        groups.add(
          MessageGroup(
            messages: [message],
            isImageGroup: false,
            isVideoGroup: false,
          ),
        );
      }
    }

    // Add last group if exists
    if (currentGroup != null) {
      groups.add(currentGroup);
    }

    return groups;
  }

  /// Extract group ID from caption (format: [GROUP:GRP_timestamp]caption)
  static String? extractGroupId(String? caption) {
    if (caption == null || caption.isEmpty) return null;

    final regex = RegExp(r'\[GROUP:(GRP_\d+)\]');
    final match = regex.firstMatch(caption);

    return match?.group(1);
  }

  /// Add group ID to caption
  static String addGroupIdToCaption(String groupId, String caption) {
    return '[GROUP:$groupId]$caption';
  }

  /// Remove group ID from caption for display
  static String cleanCaption(String? caption) {
    if (caption == null || caption.isEmpty) return '';

    return caption.replaceAll(RegExp(r'\[GROUP:GRP_\d+\]'), '').trim();
  }
}

/// Represents a group of messages
class MessageGroup {
  final List<OrderedMessages> messages;
  final bool isImageGroup;
  final bool isVideoGroup;

  MessageGroup({
    required this.messages,
    required this.isImageGroup,
    this.isVideoGroup = false,
  });

  bool get isSingleMessage => messages.length == 1;
  int get imageCount => messages.length;
  int get videoCount => messages.length;
}
