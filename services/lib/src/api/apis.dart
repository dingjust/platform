class Apis {
  const Apis();

  static get regions => () {
        return '/{baseSiteId}/regions';
      };

  static get citiesForRegion => (region) {
        return '/{baseSiteId}/regions/$region/cities';
      };

  static get districtsForCity => (city) {
        return '/{baseSiteId}/cities/$city/districts';
      };
}
