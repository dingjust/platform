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

import {RolesComponent} from './roles.component';
import {RolesService} from './roles.service';
import {RoleComponent} from './role/role.component';
import {RoleService} from './role/role.service';

const routes: Routes = [
    {
        path: 'roles',
        component: RolesComponent,
        resolve: {
            data: RolesService
        }
    },
    {
        path: 'roles/:id',
        component: RoleComponent,
        resolve: {
            data: RoleService
        }
    },
    {
        path: 'roles/:id/:name',
        component: RoleComponent,
        resolve: {
            data: RoleService
        }
    }
];

@NgModule({
    declarations: [
        RolesComponent,
        RoleComponent
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
        RolesService,
        RoleService
    ]
})
export class RolesModule {
}
