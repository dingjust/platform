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

import {FuseSharedModule} from '@fuse/shared.module';
import {FuseWidgetModule} from '@fuse/components';

import {ProductsComponent} from './products.component';
import {ProductsService} from './products.service';
import {ProductComponent} from './product/product.component';
import {ProductService} from './product/product.service';

const routes: Routes = [
    {
        path: 'products',
        component: ProductsComponent,
        resolve: {
            data: ProductsService
        }
    },
    {
        path: 'products/:id',
        component: ProductComponent,
        resolve: {
            data: ProductService
        }
    }
];

@NgModule({
    declarations: [
        ProductsComponent,
        ProductComponent
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

        FuseSharedModule,
        FuseWidgetModule
    ],
    providers: [
        ProductsService,
        ProductService
    ]
})
export class ProductsModule {
}
