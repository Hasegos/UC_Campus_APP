import 'package:uc_campus/models/json_parse.dart';

/// 공지의 임시 카테고리다.
enum NoticeCategory {
  general('일반'),
  academic('학사'),
  scholarship('장학'),
  admission('입학'),
  event('행사');

  const NoticeCategory(this.label);

  final String label;
}

/// 로컬 JSON에서 읽는 공지 정보다.
class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.category,
    required this.body,
    required this.postedAt,
    required this.sourceUrl,
    required this.isSample,
  });

  /// JSON 객체를 공지로 변환한다.
  /// 필드가 없거나 형식이 다르면 [FormatException]을 던진다.
  factory Notice.fromJson(Map<String, dynamic> json, String where) {
    return Notice(
      id: readString(json, 'id', where),
      title: readString(json, 'title', where),
      category: readEnum(NoticeCategory.values, json, 'category', where),
      body: readString(json, 'body', where),
      postedAt: readDate(json, 'postedAt', where),
      sourceUrl: readOptionalString(json, 'sourceUrl', where),
      isSample: readBool(json, 'isSample', where),
    );
  }

  final String id;
  final String title;
  final NoticeCategory category;
  final String body;
  final DateTime postedAt;
  final String? sourceUrl;
  final bool isSample;
}
