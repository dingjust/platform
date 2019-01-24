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

  static get register => (type) {
        if (type != 'BRAND') {
          return '/{baseSiteId}/factory/register';
        }

        return '/{baseSiteId}/brand/register';
      };

  static get brand => (uid) {
    return '/{baseSiteId}/brand/$uid';
  };
}
