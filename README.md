# UCheck 캠퍼스

울산과학대학교 홈페이지의 학과·공지·학사일정을 모바일 구조로 구성한 Android Flutter 학습 프로젝트입니다. 학교의 공식 앱이 아닙니다.

## 실행

Dart SDK 요구 조건은 pubspec.yaml의 ^3.12.0입니다. Android SDK와 연결된 Android 기기 또는 에뮬레이터가 필요합니다.

```bash
flutter pub get
flutter devices
flutter run
```

## 기능

- 홈: 접수 D-day, 최근 공지, 다가오는 일정, 찜 학과
- 학과 목록·상세: 검색, 계열 필터, 기본·이름·찜 우선 정렬, 찜
- 공지 목록·상세: 검색, 카테고리 필터, 세 정렬, 읽음, 북마크, 개인 메모
- 일정: 월 이동, 오늘 복귀, 카테고리 필터
- 마이: 가짜 로그인, 시스템·라이트·다크 테마, 저장한 항목 모음

## 데이터와 구조

assets/data의 JSON 세 파일을 시작할 때 한 번 읽습니다. 학과 12개, 공지 24개, 일정 16개를 메모리에 둡니다. 서버·DB·실제 API·네트워크 이미지가 없습니다.

확인된 정보는 학과 이름과 2026학년도 수시 2차 접수 기간(2026-11-11~2026-11-25)입니다. 나머지 소개·공지·일정은 isSample로 구분한 학습용 샘플이며 화면에 표시합니다. 해당 접수 공지의 실제 게시일은 확인하지 못해 게시일 미확인으로 표시합니다.

화면 내부 검색 조건은 setState, 화면 간 공유 상태는 AppState(ChangeNotifier)와 provider로 관리합니다. 상태는 영속 저장하지 않으므로 앱 프로세스를 다시 시작하면 초기화됩니다. 가짜 로그인은 비어 있지 않은 값만 확인하고 비밀번호를 저장하지 않습니다.

lib는 core / models / data / state / widgets / screens 계층으로 나뉩니다. 하단 탭은 IndexedStack과 NavigationBar, 상세 이동은 Navigator.push와 MaterialPageRoute를 사용합니다.

## 검증

```bash
dart format .
flutter analyze
flutter test
```

2026-10-13 기준 분석 0개, 테스트 48개를 통과했습니다. 7개 화면을 모바일 폭·라이트/다크·글자 1.5배로 점검하고 Android 에뮬레이터에서 시연했습니다.

## 범위

Android만 사용합니다. provider 외 런타임 패키지를 추가하지 않았습니다. 개발 기준 브랜치는 dev이며 실제 기능별 feature/uc-campus-<기능> PR을 squash 병합합니다. 배포는 별도 단계입니다.

로컬 기획 문서·AI 설정은 gitignore 대상이므로 새 clone에는 포함되지 않습니다. 과제 설명서·발표자료의 최종 작성과 AI 사용 코드의 이해 확인은 사용자가 수행합니다.
