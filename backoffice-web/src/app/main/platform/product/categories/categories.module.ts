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

import {CategoriesComponent} from './categories.component';
import {CategoriesService} from './categories.service';
import {CategoryComponent} from './category/category.component';
import {CategoryService} from './category/category.service';

const routes: Routes = [
    {
        path: 'categories',
        component: CategoriesComponent,
        resolve: {
            data: CategoriesService
        }
    },
    {
        path: 'categories/:id',
        component: CategoryComponent,
        resolve: {
            data: CategoryService
        }
    },
    {
        path: 'categories/:id/:name',
        component: CategoryComponent,
        resolve: {
            data: CategoryService
        }
    }
];

@NgModule({
    declarations: [
        CategoriesComponent,
        CategoryComponent
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
        CategoriesService,
        CategoryService
    ]
})
export class CategoriesModule {
}
