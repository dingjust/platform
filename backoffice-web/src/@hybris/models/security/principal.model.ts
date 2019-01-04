import {ItemModel} from '../item.model';

export class PrincipalModel extends ItemModel {
    uid: string;
    name: string;

    constructor(model?) {
        super(model);
        model = model || {};
        this.uid = model.uid;
        this.name = model.name || '';
    }
}

export class PrincipalGroupModel extends PrincipalModel {
    members?: PrincipalModel[];

    constructor(model?) {
        super(model);
        model = model || {};
        this.members = model.members || [];
    }
}