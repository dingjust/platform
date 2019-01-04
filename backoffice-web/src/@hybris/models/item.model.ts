export class ItemModel {
    id?: number;

    constructor(model?) {
        model = model || {};
        this.id = model.id;
    }
}