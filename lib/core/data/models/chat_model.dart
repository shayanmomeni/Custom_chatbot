class Message {
  final String text;
  final bool isSentByUser;
  final List<String>? imageUrls; // Supports multiple images

  Message({required this.text, required this.isSentByUser, this.imageUrls});

  // Serialize the Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isSentByUser': isSentByUser,
      'imageUrls': imageUrls,
    };
  }
}
