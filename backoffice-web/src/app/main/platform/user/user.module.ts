import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

import {EmployeesModule} from './employees/employees.module';
import {UserGroupsModule} from './user-groups/user-groups.module';
import {RolesModule} from './roles/roles.module';

const routes: Routes = [
    {
        path: 'employees',
        loadChildren: './employees/employees.module#EmployeesModule'
    },
    {
        path: 'user-groups',
        loadChildren: './user-groups/user-groups.module#UserGroupsModule'
    },
    {
        path: 'roles',
        loadChildren: './roles/roles.module#RolesModule'
    },
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),

        EmployeesModule,
        UserGroupsModule,
        RolesModule,
    ]
})
export class UserModule {
}
