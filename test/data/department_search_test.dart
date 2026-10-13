import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/data/sort_options.dart';
import 'package:uc_campus/models/department.dart';

void main() {
  const departments = [
    Department(
      id: 'b',
      name: '나학과',
      track: DepartmentTrack.engineering,
      summary: 'Robot 기초',
      curriculum: [],
      careers: [],
      phone: null,
      isSample: true,
    ),
    Department(
      id: 'a',
      name: '가학과',
      track: DepartmentTrack.health,
      summary: '보건 기초',
      curriculum: [],
      careers: [],
      phone: null,
      isSample: true,
    ),
    Department(
      id: 'c',
      name: '다학과',
      track: DepartmentTrack.engineering,
      summary: 'ROBOT 응용',
      curriculum: [],
      careers: [],
      phone: null,
      isSample: true,
    ),
  ];
  final repository = CampusRepository.fromLists(
    departments: departments,
    notices: [],
    events: [],
  );

  test('기본 순서와 빈 검색은 원래 순서를 유지한다', () {
    expect(repository.searchDepartments(), departments);
    expect(repository.searchDepartments(query: '  '), departments);
  });
  test('이름과 소개를 공백 제거 및 대소문자 무시로 검색한다', () {
    expect(repository.searchDepartments(query: '가학'), [departments[1]]);
    expect(repository.searchDepartments(query: ' robot '), [
      departments[0],
      departments[2],
    ]);
    expect(repository.searchDepartments(query: 'zzzz'), isEmpty);
  });
  test('계열 필터는 원래 순서를 유지한다', () {
    expect(repository.searchDepartments(track: DepartmentTrack.engineering), [
      departments[0],
      departments[2],
    ]);
  });
  test('이름순은 새 목록만 정렬한다', () {
    final result = repository.searchDepartments(sort: DepartmentSort.nameAsc);
    expect(result, [departments[1], departments[0], departments[2]]);
    result.clear();
    expect(repository.departments, departments);
  });
  test('찜 우선은 두 묶음의 JSON 순서를 유지한다', () {
    expect(
      repository.searchDepartments(
        sort: DepartmentSort.favoritesFirst,
        favoriteIds: {'c', 'a'},
      ),
      [departments[1], departments[2], departments[0]],
    );
  });
  test('검색 계열 정렬을 함께 적용한다', () {
    expect(
      repository.searchDepartments(
        query: 'robot',
        track: DepartmentTrack.engineering,
        sort: DepartmentSort.favoritesFirst,
        favoriteIds: {'c'},
      ),
      [departments[2], departments[0]],
    );
    expect(
      repository.searchDepartments(
        query: 'robot',
        track: DepartmentTrack.health,
      ),
      isEmpty,
    );
  });
}
