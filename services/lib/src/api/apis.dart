class Apis {
  const Apis();

  static get regions => (baseStoreId) {
        return '/$baseStoreId/regions';
      };

  static get citiesForRegion => (baseStoreId, region) {
        return '/$baseStoreId/regions/$region/cities';
      };

  static get districtsForCity => (baseStoreId, city) {
        return '/$baseStoreId/cities/$city/districts';
      };
}
