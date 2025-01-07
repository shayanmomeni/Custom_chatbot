class Tag {
  final String id;
  final String tagName;

  Tag({
    required this.id,
    required this.tagName,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["_id"],
      tagName: json['name'],
    );
  }
}
