import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

import {UserModule} from './user/user.module';
import {ProductModule} from './product/product.module';
import {OrderModule} from './order/order.module';

const routes: Routes = [
    {
        path: 'user',
        loadChildren: './user/user.module#UserModule'
    },
    {
        path: 'product',
        loadChildren: './product/product.module#ProductModule'
    },
    {
        path: 'order',
        loadChildren: './order/order.module#OrderModule'
    },
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),

        UserModule,
        ProductModule,
        OrderModule,
    ]
})
export class PlatformModule {
}
