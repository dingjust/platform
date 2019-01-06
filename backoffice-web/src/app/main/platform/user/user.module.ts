import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

import {EmployeesModule} from './employees/employees.module';

const routes: Routes = [
    {
        path: 'employees',
        loadChildren: './employees/employees.module#EmployeesModule'
    },
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),

        EmployeesModule,
    ]
})
export class UserModule {
}
