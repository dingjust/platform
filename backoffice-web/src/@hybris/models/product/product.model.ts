import {ItemModel} from '../item.model';

export enum MemberRating { A, B, C }

/**
 * 产品分类
 */
export class CategoryModel extends ItemModel {
    code: string;
    name: string;
    description?: string;

    constructor(props?) {
        super(props);
        props = props || {};
        this.code = props.code;
        this.name = props.name;
        this.description = props.description;
    }
}

/**
 * 阶梯价
 */
export class StaircasePriceModel extends ItemModel {
    minQuantity: number;
    maxQuantity: number;
    price: number;
    product: ProductModel;

    constructor(props?) {
        super(props);
        props = props || {};
        this.minQuantity = props.minQuantity || 0;
        this.maxQuantity = props.maxQuantity || 0;
        this.price = props.price || 0.00;
        this.product = props.product;
    }
}

/**
 * 服装产品属性
 */
export class ApparelProductAttributesModel extends ItemModel {
}

/**
 * 基本产品
 */
export class ProductModel extends ItemModel {
    code: string;
    name?: string;
    price?: number;
    thumbnail?: string;
    staircasePrices?: StaircasePriceModel[];
    privacy?: boolean;
    supercategories?: CategoryModel[];
    ratingIfPrivacy?: MemberRating;

    /**
     * Constructor
     *
     * @param props
     */
    constructor(props?) {
        super(props);
        props = props || {};
        this.code = props.code;
        this.name = props.name || '';
        this.price = props.price || 0.00;
        this.thumbnail = props.thumbnail || '';
        this.staircasePrices = props.staircasePrices || [];
        this.privacy = props.privacy || false;
        this.supercategories = props.supercategories || [];
        this.ratingIfPrivacy = props.ratingIfPrivacy || null;
    }
}

/**
 * 变式产品
 */
export class VariantProductModel extends ProductModel {
    baseProduct: string;

    constructor(props?) {
        super(props);
        props = props || {};
        this.baseProduct = props.baseProduct;
    }
}

/**
 * 服装产品
 */
export class ApparelProductModel extends ProductModel {
    variants?: ApparelSizeVariantProductModel[];
    attributes?: ApparelProductAttributesModel;
    skuID?: string;
    brand?: string;
    majorCategory?: CategoryModel;
    minorCategory?: CategoryModel;
    price1?: number;
    price2?: number;
    price3?: number;
    suggestedPrice?: number;
    gramWeight?: number;

    constructor(props?) {
        super(props);
        props = props || {};
        this.variants = props.variants || [];
        this.attributes = props.attributes;
        this.skuID = props.skuID || '';
        this.brand = props.brand || '';
        this.majorCategory = props.majorCategory;
        this.minorCategory = props.minorCategory;
        this.price1 = props.price1 || 0.00;
        this.price2 = props.price2 || 0.00;
        this.price3 = props.price3 || 0.00;
        this.suggestedPrice = props.suggestedPrice || 0.00;
        this.gramWeight = props.gramWeight || 0.000;
    }
}

/**
 * 变式产品，颜色
 */
export class ApparelStyleVariantProductModel extends VariantProductModel {
    color: ColorModel;

    constructor(props?) {
        super(props);
        props = props || {};
        this.color = props.color;
    }
}

/**
 * 变式产品，尺码
 */
export class ApparelSizeVariantProductModel extends ApparelStyleVariantProductModel {
    size: SizeModel;

    constructor(props?) {
        super(props);
        props = props || {};
        this.size = props.size;
    }
}

/**
 * 面辅料产品
 */
export class FabricProductModel extends ProductModel {
    variants?: FabricStyleVariantProductModel[];

    constructor(props?) {
        super(props);
        props = props || {};
        this.variants = props.variants || [];
    }
}

/**
 * 面辅料变式产品：颜色
 */
export class FabricStyleVariantProductModel extends VariantProductModel {
    color: ColorModel;

    constructor(props?) {
        super(props);
        props = props || {};
        this.color = props.color;
    }
}

/**
 * 风格
 */
export class StyleModel extends ItemModel {
    code: string;
    name: string;
    active: boolean;

    constructor(props?) {
        super(props);
        props = props || {};
        this.code = props.code;
        this.name = props.name;
        this.active = props.active;
    }
}

/**
 * 颜色
 */
export class ColorModel extends ItemModel {
    code: string;
    name: string;
    active: boolean;
    colorCode: string;

    constructor(props?) {
        super(props);
        props = props || {};
        this.code = props.code;
        this.name = props.name;
        this.active = props.active;
        this.colorCode = props.colorCode;
    }
}

/**
 * 尺码
 */
export class SizeModel extends ItemModel {
    code: string;
    name: string;
    active: boolean;

    constructor(props?) {
        super(props);
        props = props || {};
        this.code = props.code;
        this.name = props.name;
        this.active = props.active;
    }
}


