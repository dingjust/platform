export class ItemModel {
    id?: number;

    constructor(props?) {
        props = props || {};
        this.id = props.id;
    }
}
