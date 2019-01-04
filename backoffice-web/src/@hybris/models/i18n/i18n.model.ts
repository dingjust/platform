import {ItemModel} from '../item.model';

export class C2LItemModel extends ItemModel {
    isocode: string;
    name: string;
    active: boolean;

    constructor(model?) {
        super(model);
        model = model || {};
        this.isocode = model.isocode;
        this.name = model.name || '';
        this.active = model.active || false;
    }
}

export class CurrencyModel extends C2LItemModel {
    constructor(model?) {
        super(model);
    }
}

export class LanguageModel extends C2LItemModel {
    constructor(model?) {
        super(model);
    }
}

export class CountryModel extends C2LItemModel {
    constructor(model?) {
        super(model);
    }
}

export class RegionModel extends C2LItemModel {
    country: CountryModel;

    constructor(model?) {
        super(model);
        model = model || {};
        this.country = model.country;
    }
}

export class CityModel extends C2LItemModel {
    region: RegionModel;

    constructor(model?) {
        super(model);
        model = model || {};
        this.region = model.region;
    }
}

export class DistrictModel extends C2LItemModel {
    city: CityModel;

    constructor(model?) {
        super(model);
        model = model || {};
        this.city = model.city;
    }
}