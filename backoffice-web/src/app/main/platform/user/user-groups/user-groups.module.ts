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

import {UserGroupsComponent} from './user-groups.component';
import {UserGroupsService} from './user-groups.service';
import {UserGroupComponent} from './user-group/user-group.component';
import {UserGroupService} from './user-group/user-group.service';

const routes: Routes = [
    {
        path: 'user-groups',
        component: UserGroupsComponent,
        resolve: {
            data: UserGroupsService
        }
    },
    {
        path: 'user-groups/:id',
        component: UserGroupComponent,
        resolve: {
            data: UserGroupService
        }
    },
    {
        path: 'user-groups/:id/:name',
        component: UserGroupComponent,
        resolve: {
            data: UserGroupService
        }
    }
];

@NgModule({
    declarations: [
        UserGroupsComponent,
        UserGroupComponent
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
        UserGroupsService,
        UserGroupService
    ]
})
export class UserGroupsModule {
}
