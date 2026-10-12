import 'package:uc_campus/models/json_parse.dart';

/// 학과의 임시 계열 분류다.
enum DepartmentTrack {
  engineering('공학'),
  health('보건'),
  eduBusiness('교육·경영'),
  lifeDesign('생활·디자인');

  const DepartmentTrack(this.label);

  final String label;
}

/// 로컬 JSON에서 읽는 학과 정보다.
class Department {
  const Department({
    required this.id,
    required this.name,
    required this.track,
    required this.summary,
    required this.curriculum,
    required this.careers,
    required this.phone,
    required this.isSample,
  });

  /// JSON 객체를 학과로 변환한다.
  /// 필드가 없거나 형식이 다르면 [FormatException]을 던진다.
  factory Department.fromJson(Map<String, dynamic> json, String where) {
    return Department(
      id: readString(json, 'id', where),
      name: readString(json, 'name', where),
      track: readEnum(DepartmentTrack.values, json, 'track', where),
      summary: readString(json, 'summary', where),
      curriculum: readStringList(json, 'curriculum', where),
      careers: readStringList(json, 'careers', where),
      phone: readOptionalString(json, 'phone', where),
      isSample: readBool(json, 'isSample', where),
    );
  }

  final String id;
  final String name;
  final DepartmentTrack track;
  final String summary;
  final List<String> curriculum;
  final List<String> careers;
  final String? phone;
  final bool isSample;
}
