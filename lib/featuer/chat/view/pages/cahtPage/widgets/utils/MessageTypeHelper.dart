/// Helper class to infer message types from content
class MessageTypeHelper {
  /// Infer the message type from the type field or content
  static String inferType(String? type, String? content) {
    // If type is explicitly provided and valid, use it
    if (type != null && _isValidType(type)) {
      return type.toLowerCase();
    }

    // If no content, default to text
    if (content == null || content.isEmpty) {
      return 'text';
    }

    // Infer from file extension
    return _inferFromContent(content);
  }

  /// Check if the provided type is valid
  static bool _isValidType(String type) {
    const validTypes = [
      'video',
      'image',
      'audio',
      'file',
      'document',
      'location',
      'contacts',
      'contact',
      'text',
    ];

    return validTypes.contains(type.toLowerCase());
  }

  /// Infer type from content (file extension)
  static String _inferFromContent(String content) {
    final lower = content.toLowerCase();

    // Video formats
    if (_hasExtension(lower, ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
      return 'video';
    }

    // Image formats
    if (_hasExtension(lower, ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'])) {
      return 'image';
    }

    // Document formats
    if (_hasExtension(lower, ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx', 'ppt', 'pptx'])) {
      return 'document';
    }

    // Audio formats
    if (_hasExtension(lower, ['mp3', 'wav', 'aac', 'm4a', 'ogg', 'flac'])) {
      return 'audio';
    }

    // Default to text
    return 'text';
  }

  /// Check if content has any of the given extensions
  static bool _hasExtension(String content, List<String> extensions) {
    return extensions.any((ext) => content.endsWith('.$ext'));
  }

  /// Get icon for message type
  static String getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return '🎥';
      case 'image':
        return '📷';
      case 'audio':
        return '🎵';
      case 'document':
      case 'file':
        return '📄';
      case 'location':
        return '📍';
      case 'contact':
      case 'contacts':
        return '👤';
      default:
        return '💬';
    }
  }

  /// Get display text for message type
  static String getDisplayTextForType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return 'Video';
      case 'image':
        return 'Photo';
      case 'audio':
        return 'Voice message';
      case 'document':
      case 'file':
        return 'Document';
      case 'location':
        return 'Location';
      case 'contact':
      case 'contacts':
        return 'Contact';
      default:
        return 'Message';
    }
  }
}