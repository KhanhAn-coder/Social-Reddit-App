class Comment{
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profiePic;

//<editor-fold desc="Data Methods">
  const Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profiePic,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          createdAt == other.createdAt &&
          postId == other.postId &&
          username == other.username &&
          profiePic == other.profiePic);

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      createdAt.hashCode ^
      postId.hashCode ^
      username.hashCode ^
      profiePic.hashCode;

  @override
  String toString() {
    return 'Comment{' +
        ' id: $id,' +
        ' text: $text,' +
        ' createdAt: $createdAt,' +
        ' postId: $postId,' +
        ' username: $username,' +
        ' profiePic: $profiePic,' +
        '}';
  }

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profiePic,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profiePic: profiePic ?? this.profiePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'text': this.text,
      'createdAt': this.createdAt.toUtc(),
      'postId': this.postId,
      'username': this.username,
      'profiePic': this.profiePic,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: map['createdAt'].toDate(),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profiePic: map['profiePic'] ?? '',
    );
  }

//</editor-fold>
}