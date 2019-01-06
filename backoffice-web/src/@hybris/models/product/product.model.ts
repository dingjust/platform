import {MatChipInputEvent} from '@angular/material';

import {FuseUtils} from '@fuse/utils';

import {ItemModel} from '../item.model';

export class UnitModel extends ItemModel {
    code: string;
    name: string;

    constructor(model?) {
        super(model);
        model = model || {};
        this.code = model.code;
        this.name = model.name;
    }
}

export class CatalogModel {
    id: string;
    name: string;

    constructor(model?) {
        model = model || {};
        this.id = model.id;
        this.name = model.name;
    }
}

export class CatalogVersionModel extends ItemModel {
    catalog: CatalogModel;
    version: string;

    constructor(model?) {
        super(model);
        model = model || {};
        this.catalog = model.catalog;
        this.version = model.version;
    }
}

export class CategoryModel extends ItemModel {
    code: string;
    name: string;
    description?: string;
    catalogVersion: CatalogVersionModel;

    constructor(model?) {
        super(model);
        model = model || {};
        this.code = model.code;
        this.name = model.name;
        this.description = model.description;
        this.catalogVersion = model.catalogVersion;
    }
}

export class ProductModel {
    id: string;
    name: string;
    handle: string;
    description: string;
    categories: string[];
    tags: string[];
    images: {
        default: boolean,
        id: string,
        url: string,
        type: string
    }[];
    priceTaxExcl: number;
    priceTaxIncl: number;
    taxRate: number;
    comparedPrice: number;
    quantity: number;
    sku: string;
    width: string;
    height: string;
    depth: string;
    weight: string;
    extraShippingFee: number;
    active: boolean;

    /**
     * Constructor
     *
     * @param product
     */
    constructor(product?) {
        product = product || {};
        this.id = product.id || FuseUtils.generateGUID();
        this.name = product.name || '';
        this.handle = product.handle || FuseUtils.handleize(this.name);
        this.description = product.description || '';
        this.categories = product.categories || [];
        this.tags = product.tags || [];
        this.images = product.images || [];
        this.priceTaxExcl = product.priceTaxExcl || 0;
        this.priceTaxIncl = product.priceTaxIncl || 0;
        this.taxRate = product.taxRate || 0;
        this.comparedPrice = product.comparedPrice || 0;
        this.quantity = product.quantity || 0;
        this.sku = product.sku || 0;
        this.width = product.width || 0;
        this.height = product.height || 0;
        this.depth = product.depth || 0;
        this.weight = product.weight || 0;
        this.extraShippingFee = product.extraShippingFee || 0;
        this.active = product.active || true;
    }

    /**
     * Add category
     *
     * @param {MatChipInputEvent} event
     */
    addCategory(event: MatChipInputEvent): void {
        const input = event.input;
        const value = event.value;

        // Add category
        if (value) {
            this.categories.push(value);
        }

        // Reset the input value
        if (input) {
            input.value = '';
        }
    }

    /**
     * Remove category
     *
     * @param category
     */
    removeCategory(category): void {
        const index = this.categories.indexOf(category);

        if (index >= 0) {
            this.categories.splice(index, 1);
        }
    }

    /**
     * Add tag
     *
     * @param {MatChipInputEvent} event
     */
    addTag(event: MatChipInputEvent): void {
        const input = event.input;
        const value = event.value;

        // Add tag
        if (value) {
            this.tags.push(value);
        }

        // Reset the input value
        if (input) {
            input.value = '';
        }
    }

    /**
     * Remove tag
     *
     * @param tag
     */
    removeTag(tag): void {
        const index = this.tags.indexOf(tag);

        if (index >= 0) {
            this.tags.splice(index, 1);
        }
    }
}
