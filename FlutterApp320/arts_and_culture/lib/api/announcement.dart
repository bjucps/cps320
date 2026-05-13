class AnnouncementData {
  final int id;
  final String title;
  final String body;
  final String type;

  AnnouncementData({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
    );
  }
}
