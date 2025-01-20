class Message {
  final String text;
  final bool isSentByUser;

  Message({required this.text, required this.isSentByUser});

  // Add this method to serialize the Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isSentByUser': isSentByUser,
    };
  }
}
