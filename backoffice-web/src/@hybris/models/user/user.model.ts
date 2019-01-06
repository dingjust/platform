import {PrincipalGroupModel, PrincipalModel} from '../security/principal.model';
import {ItemModel} from '../item.model';
import {CountryModel} from '../i18n/i18n.model';
import {LineOfBusiness} from './enums/line-of-business';

export class UserModel extends PrincipalModel {
    constructor(model?) {
        super(model);
    }
}

export class EmployeeModel extends UserModel {
    constructor(model?) {
        super(model);
    }
}

export class CustomerModel extends UserModel {
    constructor(model?) {
        super(model);
    }
}

export class UserGroupModel extends PrincipalGroupModel {
    constructor(model?) {
        super(model);
    }
}

export class RoleModel extends UserGroupModel {
    authorities: string[];

    constructor(model?) {
        super(model);
        model = model || {};
        this.authorities = model.authorities;
    }
}

export class CompanyModel extends UserGroupModel {
    contact?: UserModel;
    country?: CountryModel;
    lineOfBusiness?: LineOfBusiness;
    buyer?: boolean;
    supplier?: boolean;
    manufacturer?: boolean;
    carrier?: boolean;

    constructor(model?) {
        super(model);
        model = model || {};
        this.contact = model.contact || {};
        this.country = model.country || {};
        this.lineOfBusiness = model.lineOfBusiness;
        this.buyer = model.buyer || false;
        this.supplier = model.supplier || false;
        this.manufacturer = model.manufacturer || false;
        this.carrier = model.carrier || false;
    }
}

export class TitleModel extends ItemModel {
    code: string;
    name: string;

    constructor(model?) {
        super(model);
        model = model || {};
        this.code = model.code;
        this.name = model.name || '';
    }
}

