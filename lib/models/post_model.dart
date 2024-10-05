class Post{
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final String userName;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;

//<editor-fold desc="Data Methods">
  const Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfilePic,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.userName,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          link == other.link &&
          description == other.description &&
          communityName == other.communityName &&
          communityProfilePic == other.communityProfilePic &&
          upVotes == other.upVotes &&
          downVotes == other.downVotes &&
          commentCount == other.commentCount &&
          userName == other.userName &&
          uid == other.uid &&
          type == other.type &&
          createdAt == other.createdAt &&
          awards == other.awards);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      link.hashCode ^
      description.hashCode ^
      communityName.hashCode ^
      communityProfilePic.hashCode ^
      upVotes.hashCode ^
      downVotes.hashCode ^
      commentCount.hashCode ^
      userName.hashCode ^
      uid.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      awards.hashCode;

  @override
  String toString() {
    return 'Post{' +
        ' id: $id,' +
        ' title: $title,' +
        ' link: $link,' +
        ' description: $description,' +
        ' communityName: $communityName,' +
        ' communityProfilePic: $communityProfilePic,' +
        ' upVotes: $upVotes,' +
        ' downVotes: $downVotes,' +
        ' commentCount: $commentCount,' +
        ' userName: $userName,' +
        ' uid: $uid,' +
        ' type: $type,' +
        ' createdAt: $createdAt,' +
        ' awards: $awards,' +
        '}';
  }

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    String? userName,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      userName: userName ?? this.userName,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'link': this.link,
      'description': this.description,
      'communityName': this.communityName,
      'communityProfilePic': this.communityProfilePic,
      'upVotes': this.upVotes,
      'downVotes': this.downVotes,
      'commentCount': this.commentCount,
      'userName': this.userName,
      'uid': this.uid,
      'type': this.type,
      'createdAt': createdAt.toUtc(),
      'awards': this.awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      link: map['link'] ?? '',
      description: map['description'] ?? '',
      communityName: map['communityName'] ?? '',
      communityProfilePic: map['communityProfilePic'] ?? '',
      upVotes:  List<String>.from(map['upVotes']),
      downVotes:  List<String>.from(map['downVotes']),
      commentCount: map['commentCount'] as int,
      userName: map['userName'] ?? '',
      uid: map['uid'] ?? '',
      type: map['type'] ?? '',
      createdAt: map['createdAt'].toDate(),
      awards: List<String>.from(map['awards']),
    );
  }

//</editor-fold>
}