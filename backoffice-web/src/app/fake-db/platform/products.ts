import {ApparelProductModel, CategoryModel} from '@hybris/models/product/product.model';


export class PlatformProductsFakeDb {
    public static categories: CategoryModel[] = [
        {
            id: 1,
            code: 'categories',
            name: '产品分类根目录',
        }
    ];

    public static products: ApparelProductModel[] = [
        {
            id: 1,
            code: 'P00000001',
            name: '产品1',
            skuID: 'PSKU00000001',
            supercategories: PlatformProductsFakeDb.categories,
        },
        {
            id: 2,
            code: 'P00000002',
            name: '产品2',
            skuID: 'PSKU00000002',
            supercategories: PlatformProductsFakeDb.categories,
        },
    ];
}
