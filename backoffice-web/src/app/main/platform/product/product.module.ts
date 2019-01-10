import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

import {CategoriesModule} from './categories/categories.module';
import {ProductsModule} from './products/products.module';

const routes: Routes = [
    {
        path: 'categories',
        loadChildren: './categories/categories.module#CategoriesModule'
    },
    {
        path: 'products',
        loadChildren: './products/products.module#ProductsModule'
    },
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),

        CategoriesModule,
        ProductsModule,
    ]
})
export class ProductModule {
}
