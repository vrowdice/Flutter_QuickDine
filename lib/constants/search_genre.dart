/// HotPepper API `genre` 파라미터 — 검색 장르 필터
class SearchGenreOption {
  const SearchGenreOption({this.code});

  /// `null` = 전체 (API 파라미터 생략)
  final String? code;
}

/// 장르 필터 목록 — 코드 순서·값은 API 규격과 일치해야 함
const kSearchGenreOptions = [
  SearchGenreOption(),
  SearchGenreOption(code: 'G001'),
  SearchGenreOption(code: 'G004'),
  SearchGenreOption(code: 'G006'),
  SearchGenreOption(code: 'G007'),
  SearchGenreOption(code: 'G008'),
  SearchGenreOption(code: 'G009'),
  SearchGenreOption(code: 'G014'),
];
