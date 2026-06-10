/// HotPepper API `range` 파라미터 — 검색 반경 5단계
///
/// API 규격: 1=300m, 2=500m, 3=1000m, 4=2000m, 5=3000m
const kSearchRadiusRanges = [1, 2, 3, 4, 5];

/// range 코드 → 실제 반경(미터). UI 라벨 및 주석용.
const kSearchRadiusMeters = {
  1: 300,
  2: 500,
  3: 1000,
  4: 2000,
  5: 3000,
};

const kDefaultSearchRadius = 2;

/// UI/API에 전달된 range 값을 HotPepper 허용 범위(1~5)로 보정
int clampSearchRadius(int range) {
  if (kSearchRadiusRanges.contains(range)) return range;
  if (range < kSearchRadiusRanges.first) return kSearchRadiusRanges.first;
  if (range > kSearchRadiusRanges.last) return kSearchRadiusRanges.last;
  return kDefaultSearchRadius;
}

int searchRadiusMeters(int range) =>
    kSearchRadiusMeters[clampSearchRadius(range)] ?? 500;
