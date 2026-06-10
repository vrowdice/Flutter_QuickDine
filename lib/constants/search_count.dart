/// API 검색 시 고정 반경 (HotPepper range 2 = 500m)
const kSearchCountOptions = [10, 20, 30, 50, 100];

const kDefaultSearchCount = 20;

int clampSearchCount(int count) {
  if (kSearchCountOptions.contains(count)) return count;
  if (count < kSearchCountOptions.first) return kSearchCountOptions.first;
  if (count > kSearchCountOptions.last) return kSearchCountOptions.last;
  return kDefaultSearchCount;
}
