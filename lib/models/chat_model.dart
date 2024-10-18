class Chat{
  final String senderId;
  final String friendId;
  final String text;
  final String id;
  final String senderProfilePic;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const Chat({
    required this.senderId,
    required this.friendId,
    required this.text,
    required this.id,
    required this.senderProfilePic,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          runtimeType == other.runtimeType &&
          senderId == other.senderId &&
          friendId == other.friendId &&
          text == other.text &&
          id == other.id &&
          senderProfilePic == other.senderProfilePic &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      senderId.hashCode ^
      friendId.hashCode ^
      text.hashCode ^
      id.hashCode ^
      senderProfilePic.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'Chat{' +
        ' senderId: $senderId,' +
        ' friendId: $friendId,' +
        ' text: $text,' +
        ' id: $id,' +
        ' senderProfilePic: $senderProfilePic,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  Chat copyWith({
    String? senderId,
    String? friendId,
    String? text,
    String? id,
    String? senderProfilePic,
    DateTime? createdAt,
  }) {
    return Chat(
      senderId: senderId ?? this.senderId,
      friendId: friendId ?? this.friendId,
      text: text ?? this.text,
      id: id ?? this.id,
      senderProfilePic: senderProfilePic ?? this.senderProfilePic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': this.senderId,
      'friendId': this.friendId,
      'text': this.text,
      'id': this.id,
      'senderProfilePic': this.senderProfilePic,
      'createdAt': this.createdAt.toUtc(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'] ?? '',
      friendId: map['friendId'] ?? '',
      text: map['text'] ?? '',
      id: map['id'] ?? '',
      senderProfilePic: map['senderProfilePic'] ?? '',
      createdAt: map['createdAt'].toDate(),
    );
  }

//</editor-fold>
}