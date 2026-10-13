import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/data/sort_options.dart';
import 'package:uc_campus/models/notice.dart';

void main() {
  final notices = [
    Notice(
      id: 'b',
      title: '나 안내',
      category: NoticeCategory.academic,
      body: 'Course 샘플',
      postedAt: DateTime(2026, 9),
      sourceUrl: null,
      isSample: true,
    ),
    Notice(
      id: 'a',
      title: '나 안내',
      category: NoticeCategory.general,
      body: '안내',
      postedAt: DateTime(2026, 9),
      sourceUrl: null,
      isSample: true,
    ),
    Notice(
      id: 'c',
      title: '가 안내',
      category: NoticeCategory.academic,
      body: 'COURSE 샘플',
      postedAt: DateTime(2026, 10),
      sourceUrl: null,
      isSample: true,
    ),
  ];
  final repository = CampusRepository.fromLists(
    departments: [],
    notices: notices,
    events: [],
  );
  test('최신·오래된순·제목순과 동률 id 순서를 적용한다', () {
    expect(repository.searchNotices().map((n) => n.id), ['c', 'a', 'b']);
    expect(repository.searchNotices(sort: NoticeSort.oldest).map((n) => n.id), [
      'a',
      'b',
      'c',
    ]);
    expect(
      repository.searchNotices(sort: NoticeSort.titleAsc).map((n) => n.id),
      ['c', 'a', 'b'],
    );
    expect(repository.notices, notices);
  });
  test('검색·카테고리·정렬을 조합하고 빈 검색 결과를 처리한다', () {
    expect(
      repository
          .searchNotices(
            query: ' course ',
            category: NoticeCategory.academic,
            sort: NoticeSort.oldest,
          )
          .map((n) => n.id),
      ['b', 'c'],
    );
    expect(
      repository
          .searchNotices(query: '나', category: NoticeCategory.general)
          .map((n) => n.id),
      ['a'],
    );
    expect(repository.searchNotices(query: 'zzzz'), isEmpty);
    expect(repository.searchNotices(query: ' ').length, 3);
    expect(repository.recentNotices(limit: 1).first.id, 'c');
    expect(repository.recentNotices(limit: 0), isEmpty);
  });
}
