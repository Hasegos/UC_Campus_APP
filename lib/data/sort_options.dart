/// 학과 목록의 정렬 방식이다.
enum DepartmentSort {
  defaultOrder('기본 순서'),
  nameAsc('이름순'),
  favoritesFirst('찜 우선');

  const DepartmentSort(this.label);

  final String label;
}

/// 공지 목록의 정렬 방식이다.
enum NoticeSort {
  newest('최신순'),
  oldest('오래된순'),
  titleAsc('제목순');

  const NoticeSort(this.label);

  final String label;
}
