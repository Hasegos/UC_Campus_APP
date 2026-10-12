import 'dart:convert';

/// JSON 문자열을 객체 배열로 해석한다.
/// 형식이 다르면 [FormatException]을 던진다.
List<Map<String, dynamic>> decodeObjectList(String source, String where) {
  final dynamic decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException catch (error) {
    throw FormatException('$where: 올바른 JSON이 아니다. ${error.message}');
  }

  if (decoded is! List<dynamic>) {
    throw FormatException('$where: 최상위 값은 배열이어야 한다.');
  }

  return List<Map<String, dynamic>>.unmodifiable(
    decoded.indexed.map((entry) {
      final (index, value) = entry;
      if (value is! Map<String, dynamic>) {
        throw FormatException('$where[$index]: 객체여야 한다.');
      }
      return value;
    }),
  );
}

/// 비어 있지 않은 필수 문자열 필드를 읽는다.
String readString(Map<String, dynamic> json, String key, String where) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$where.$key: 비어 있지 않은 문자열이어야 한다.');
  }
  return value;
}

/// 선택 문자열 필드를 읽고 없거나 `null`이면 `null`을 돌려준다.
String? readOptionalString(
  Map<String, dynamic> json,
  String key,
  String where,
) {
  if (!json.containsKey(key) || json[key] == null) {
    return null;
  }
  return readString(json, key, where);
}

/// 필수 bool 필드를 읽는다.
bool readBool(Map<String, dynamic> json, String key, String where) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('$where.$key: bool이어야 한다.');
  }
  return value;
}

/// 비어 있지 않은 문자열로 이루어진 필수 배열을 읽는다.
List<String> readStringList(
  Map<String, dynamic> json,
  String key,
  String where,
) {
  final value = json[key];
  if (value is! List<dynamic>) {
    throw FormatException('$where.$key: 문자열 배열이어야 한다.');
  }

  return List<String>.unmodifiable(
    value.indexed.map((entry) {
      final (index, item) = entry;
      if (item is! String || item.trim().isEmpty) {
        throw FormatException('$where.$key[$index]: 비어 있지 않은 문자열이어야 한다.');
      }
      return item;
    }),
  );
}

/// `yyyy-MM-dd` 형식의 필수 날짜를 읽는다.
DateTime readDate(Map<String, dynamic> json, String key, String where) {
  final value = readString(json, key, where);
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) {
    throw FormatException('$where.$key: yyyy-MM-dd 날짜여야 한다.');
  }

  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) {
    throw FormatException('$where.$key: 존재하는 날짜여야 한다.');
  }
  return date;
}

/// 필수 enum 필드를 이름으로 찾아 읽는다.
T readEnum<T extends Enum>(
  List<T> values,
  Map<String, dynamic> json,
  String key,
  String where,
) {
  final value = readString(json, key, where);
  try {
    return values.byName(value);
  } on ArgumentError {
    throw FormatException('$where.$key: 알 수 없는 enum 값 "$value"이다.');
  }
}
