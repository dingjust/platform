import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {
    MatButtonModule,
    MatChipsModule,
    MatExpansionModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatPaginatorModule,
    MatRippleModule,
    MatSelectModule,
    MatSnackBarModule,
    MatSortModule,
    MatTableModule,
    MatTabsModule
} from '@angular/material';
import {NgxChartsModule} from '@swimlane/ngx-charts';
import {AgmCoreModule} from '@agm/core';

import {FuseSharedModule} from '@fuse/shared.module';
import {FuseWidgetModule} from '@fuse/components';

import {OrdersComponent} from './orders.component';
import {OrdersService} from './orders.service';
import {OrderComponent} from './order/order.component';
import {OrderService} from './order/order.service';

const routes: Routes = [
    {
        path: 'orders',
        component: OrdersComponent,
        resolve: {
            data: OrdersService
        }
    },
    {
        path: 'orders/:id',
        component: OrderComponent,
        resolve: {
            data: OrderService
        }
    }
];

@NgModule({
    declarations: [
        OrdersComponent,
        OrderComponent
    ],
    imports: [
        RouterModule.forChild(routes),

        MatButtonModule,
        MatChipsModule,
        MatExpansionModule,
        MatFormFieldModule,
        MatIconModule,
        MatInputModule,
        MatPaginatorModule,
        MatRippleModule,
        MatSelectModule,
        MatSortModule,
        MatSnackBarModule,
        MatTableModule,
        MatTabsModule,

        NgxChartsModule,
        AgmCoreModule.forRoot({
            apiKey: 'AIzaSyD81ecsCj4yYpcXSLFcYU97PvRsE_X8Bx8'
        }),

        FuseSharedModule,
        FuseWidgetModule
    ],
    providers: [
        OrdersService,
        OrderService
    ]
})
export class OrdersModule {
}
