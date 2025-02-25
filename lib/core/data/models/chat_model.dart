// chat_model.dart
class Message {
  final String text;
  final bool isSentByUser;
  final List<String>? imageUrls;

  // NEW: List of aspect objects, each with aspectName + imageUrl
  final List<AspectItem>? aspects;

  Message({
    required this.text,
    required this.isSentByUser,
    this.imageUrls,
    this.aspects,
  });
}

// NEW: A small model to store aspectName + imageUrl
class AspectItem {
  final String aspectName;
  final String imageUrl;

  AspectItem({
    required this.aspectName,
    required this.imageUrl,
  });
}
