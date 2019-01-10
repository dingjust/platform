import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

import {OrdersModule} from './orders/orders.module';

const routes: Routes = [
    {
        path: 'orders',
        loadChildren: './orders/orders.module#OrdersModule'
    },
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),

        OrdersModule,
    ]
})
export class OrderModule {
}
