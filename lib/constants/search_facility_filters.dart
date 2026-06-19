/// HotPepper API facility filters — query param name when enabled (`=1`)
class SearchFacilityFilterOption {
  const SearchFacilityFilterOption(this.apiParam);

  final String apiParam;
}

const kSearchFacilityFilters = [
  SearchFacilityFilterOption('parking'),
  SearchFacilityFilterOption('private_room'),
  SearchFacilityFilterOption('wifi'),
  SearchFacilityFilterOption('card'),
  SearchFacilityFilterOption('non_smoking'),
];

Map<String, bool> initialFacilityFilterState() => {
      for (final option in kSearchFacilityFilters) option.apiParam: false,
    };
